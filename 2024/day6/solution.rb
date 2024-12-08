# --- Day 6: Guard Gallivant ---

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

  def solve_part_one
    @input.map! { |line| line.split("") }
    @y_max = @input.size-1
    @x_max = @input.first.size-1

    start

    @input.flatten.tally["X"]
  end

  def move(direction, x, y)
    @input[y][x] = "X"

    case direction
    when :up
      return unless on_map?(x, y-1)
      if @input[y-1][x] == "#"
        move(:right, x, y)
      else
        move(direction, x, y-1)
      end
    when :down
      return unless on_map?(x, y+1)
      if @input[y+1][x] == "#"
        move(:left, x, y)
      else
        move(direction, x, y+1)
      end
    when :right
      return unless on_map?(x+1, y)
      if @input[y][x+1] == "#"
        move(:down, x, y)
      else
        move(direction, x+1, y)
      end
    when :left
      return unless on_map?(x-1, y)
      if @input[y][x-1] == "#"
        move(:up, x, y)
      else
        move(direction, x-1, y)
      end
    end
  end

  def on_map?(x, y)
    return false if x < 0 || y < 0 || x > @x_max || y > @y_max
    true
  end

  def start
    @input.each_with_index do |line, i|
      if line.include?("<")
        move(:right, line.index("<"), i)
      elsif line.include?(">")
        move(:left, line.index(">"), i)
      elsif line.include?("^")
        move(:up, line.index("^"), i)
      elsif line.include?("v")
        move(:down, line.index("v"), i)
      end
    end
  end

########## PART 2

  def solve_part_two
    result = 0

    result
  end

end

Solution.process_args
