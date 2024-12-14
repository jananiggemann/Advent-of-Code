# --- Day 14: Restroom Redoubt ---

require "optparse"
require "pry"

class Solution
  def self.process_args
    options = {}

    OptionParser.new do |opts|
      opts.banner = "Usage: solution.rb [options]"

      opts.on("-r", "--run", "Run the solution") { options[:run] = true }
      opts.on("-t", "--time", "Time the solution") { options[:time_run] = true }
      opts.on("-f", "--filename FILENAME", "Input filename") do |filename|
        options[:filename] = filename
      end
    end.parse!

    solution = new
    solution.set_input_filename(options[:filename]) if options[:filename]
    solution.run if options[:run]
    solution.time_run if options[:time_run]
  end

  def initialize
    @dir = __dir__
    @input = read_input_line_by_line
  end

  def run
    puts("Part One: ", solve_part_one)
    puts("Part Two: ", solve_part_two)
  end

  def time_run
    start_time = Time.now
    30.times do
      @input = read_input_line_by_line
      solve_part_one
      solve_part_two
    end
     puts "Execution time: #{Time.now-start_time} seconds"
  end

  def read_input(filename = "input.txt")
    filepath = File.join(@dir, filename)
    File.open(filepath, "a+")  unless File.exist?(filename)
    File.read(filepath)
  end

  def read_input_line_by_line(filename = "input.txt")
    filepath = File.join(@dir, filename)
    File.open(filepath, "a+")  unless File.exist?(filename)
    File.readlines(filename, chomp: true)
  end

  def set_input_filename(filename)
    @input = read_input_line_by_line(filename)
  end

########## PART 1

  def solve_part_one
    positions = @input.map{ |i| i.scan(/-*\d+/).each_slice(2).map { |x, y| [x.to_i, y.to_i] }}

    room = Array.new(103) { Array.new(101, 0) }

    positions.each do |position|
      room = move_robot(room, position[0], position[1], 100).last
    end

    q1 = room.slice(0, 51).map{ |r| r.slice(0,50)}
    q2 = room.slice(0, 51).map{ |r| r.slice(51,101)}
    q3 = room.slice(52, 103).map{ |r| r.slice(0,50)}
    q4 = room.slice(52, 103).map{ |r| r.slice(51,101)}

    q1.flatten.sum * q2.flatten.sum * q3.flatten.sum * q4.flatten.sum
  end

  def move_robot(room, position, velocity, time)
    x = position.first
    y = position.last

    if x >= 0
      x = (x + (time * velocity[0])) % room.first.size
    else
      if (time*velocity[0]).abs > x
        x = (((time*velocity[0].abs)-x) % room.first.size) * -1
      else
        x = (x + (time*velocity[0])) % room.first.size
      end
    end

    if y >= 0
      y = (y + (time * velocity[1])) % room.size
    else
      if (time*velocity[1]).abs > y
        y = (((time*velocity[1].abs)-y) % room.size) * -1
      else
        y = (y + (time*velocity[1])) % room.size
      end
    end

    room[y][x] += 1
    [[x, y], room]
  end

########## PART 2

  def solve_part_two
    positions = @input.map{ |i| i.scan(/-*\d+/).each_slice(2).map { |x, y| [x.to_i, y.to_i] }}

    room = Array.new(103) { Array.new(101, 0) }
    possible_tree_at_sec = []

    10000.times do |t|
      positions.each do |position|
        move = move_robot(room, position[0], position[1], 1)
        room = move[1]
        room[position[0][1]][position[0][0]] -= 1 unless t == 0
        position[0] = move[0]
      end

      if possible_christmas_tree?(room) && possible_christmas_tree?(room.transpose)
        possible_tree_at_sec << t+1

        print("\n ", t+1, "\n ------------------------------------------------------- \n")

        room.each do |row|
          row.each do |tile|
            if tile.zero?
              print(" .")
            else
              print(" o")
            end
          end
          print("| \n")
        end
        sleep(0.4)
      end
    end

    possible_tree_at_sec
  end

  def possible_christmas_tree?(room)
    sum_of_robots_per_row = []
    rows_with_robots = []

    room.each_with_index do |row, i|
      sum = row.sum
      if sum < 36 && sum > 15
        sum_of_robots_per_row << sum
        rows_with_robots << i
      end
    end

    sum_of_robots_per_row.uniq.each do |e|
      rows_with_robots.delete_at(sum_of_robots_per_row.index(e))
      sum_of_robots_per_row.delete_at(sum_of_robots_per_row.index(e))
    end

    unless sum_of_robots_per_row.empty?
      sum_of_robots_per_row.each_with_index do |r, i|
        total_robots_in_area = 0
        index = rows_with_robots[i]
        if (index-r)>0
          room[(index-r)..index].each do |row|
            total_robots_in_area += row.sum
          end

          return true if total_robots_in_area > 200
        end
      end
    end
  end
end

Solution.process_args
