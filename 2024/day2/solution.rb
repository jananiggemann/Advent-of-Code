# --- Day 2: Red-Nosed Reports ---

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
    count = 0

    @input.each do |line|
      levels = line.split(" ")
      count += check(levels.map(&:to_i))
    end
    count
  end

  def check(levels)
    if levels.uniq.length == levels.length
      return 1 if asc(levels) || dec(levels)
    end
    0
  end

  def asc(levels)
    return false unless levels.sort == levels

    levels.each_with_index.all? do |level, i|
      levels[i+1].nil? || (levels[i+1] - level) <= 3
    end
  end

  def dec(levels)
    return false unless levels.sort.reverse == levels

    levels.each_with_index.all? do |level, i|
      levels[i+1].nil? || (level - levels[i+1]) <= 3
    end
  end

########## PART 2

  def solve_part_two
    count = 0

    @input.each do |line|
      levels = line.split(" ")
      levels = levels.map(&:to_i)

      if check(levels) == 1
        count += 1
      else
        count += check_with_single_level_removed(levels)
      end
    end
    count
  end

  def check_with_single_level_removed(levels)
    levels.each_with_index do |level, i|
      remaining_levels = levels.reject.with_index { |_, index| index == i }
      return 1 if check(remaining_levels) == 1
    end
    0
  end
end

Solution.process_args
