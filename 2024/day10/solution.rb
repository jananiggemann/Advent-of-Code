# --- Day 10: Hoof It ---

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
    100.times do
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

# Hiking trails:
# - any path that starts at height 0, ends at height 9
# - always increases by a height of exactly 1 at each step
# - Hiking trails never include diagonal steps
# - trailhead is any position that starts one or more hiking trails
# - score: number of different 9s reachable

# - goal: the sum of the scores of all trailheads

  def solve_part_one
    map = @input.dup.map { |line| line.split("").map(&:to_i) }
    paths = 0
    @distinct = 0

    map.each_with_index do |line, i|
      if line.include?(0)
        line.each_with_index do |num, pos|
          if num.zero?
            @score = []
            find_paths(map, i, pos, num)
            paths += @score.uniq.size
          end
        end
      end
    end

    paths
  end

  def find_paths(map, row, pos, num)
    up(map, row, pos, num)
    down(map, row, pos, num)
    right(map, row, pos, num)
    left(map, row, pos, num)
  end

  def up(map, row, pos, num)
    return if row.zero? || map[row-1][pos] != num+1

    if num+1 == 9
      @distinct += 1
      @score << ((row-1)*map.first.size)+pos
    else
      find_paths(map, row-1, pos, num+1)
    end
  end

  def down(map, row, pos, num)
    return if row+1 >= map.size || map[row+1][pos] != num+1

    if num+1 == 9
      @distinct += 1
      @score << ((row+1)*map.first.size)+pos
    else
      find_paths(map, row+1, pos, num+1)
    end
  end

  def right(map, row, pos, num)
    return if pos+1 >= map.first.size || map[row][pos+1] != num+1

    if num+1 == 9
      @distinct += 1
      @score << ((row)*map.first.size)+pos+1
    else
      find_paths(map, row, pos+1, num+1)
    end
  end

  def left(map, row, pos, num)
    return if pos.zero? || map[row][pos-1] != num+1

    if num+1 == 9
      @distinct += 1
      @score << ((row)*map.first.size)+pos-1
    else
      find_paths(map, row, pos-1, num+1)
    end
  end

########## PART 2

  def solve_part_two
    @distinct
  end
end

Solution.process_args
