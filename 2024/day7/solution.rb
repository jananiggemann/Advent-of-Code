# --- Day 7: Bridge Repair ---

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
    result = 0

    input = @input.dup
    input.map! { |line| line.split(":") }
    input.map! do |line|
      [line[0].to_i, line[1].split(" ").map(&:to_i)]
    end

    input.each_with_index do |equation, i|
      test_value = equation[0]
      numbers = equation[1]
      result += valid_equation(numbers.shift(1).first, numbers, test_value)
    end

    result
  end

  def valid_equation(number, numbers, test_value)
    numbers = numbers.dup
    result = 0
    return result if numbers.empty?
    next_number = numbers.shift(1).first

    # plus +
    new_plus = number + next_number
    return new_plus if new_plus == test_value && numbers.empty?
    result = valid_equation(new_plus, numbers, test_value)
    return result unless result.zero?

    # mal *
    new_mal = number * next_number
    return new_mal if new_mal == test_value && numbers.empty?
    result = valid_equation(new_mal, numbers, test_value)
    result
  end

########## PART 2

  def solve_part_two
    result = 0

    input = @input.dup
    input.map! { |line| line.split(":") }
    input.map! do |line|
      [line[0].to_i, line[1].split(" ").map(&:to_i)]
    end

    input.each_with_index do |equation, i|
      test_value = equation[0]
      numbers = equation[1]
      result += valid_concat_equation(numbers.shift(1).first, numbers, test_value)
    end

    result
  end

  def valid_concat_equation(number, numbers, test_value)
    numbers = numbers.dup
    result = 0
    return result if numbers.empty?
    next_number = numbers.shift(1).first

    # plus +
    new_plus = number + next_number
    return new_plus if new_plus == test_value && numbers.empty?
    result = valid_concat_equation(new_plus, numbers, test_value)
    return result unless result.zero?

    # mal *
    new_mal = number * next_number
    return new_mal if new_mal == test_value && numbers.empty?
    result = valid_concat_equation(new_mal, numbers, test_value)
    return result unless result.zero?

    # concatenate ||
    new_concat = (number.to_s + next_number.to_s).to_i
    return new_concat if new_concat == test_value && numbers.empty?
    result = valid_concat_equation(new_concat, numbers, test_value)
    result
  end
end

Solution.process_args
