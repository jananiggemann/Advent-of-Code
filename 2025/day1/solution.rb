# --- Day 1: Secret Entrance ---

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
    @input.map! do |dial|
      dial.delete('R').sub('L', '-').to_i
    end

    password = 0
    pointer = 50

    @input.each do |dial|
      pointer = (pointer += dial) % 100
      pointer = 100 - pointer * (-1) if pointer < 0
      password += 1 if pointer == 0
    end

    password
  end

########## PART 2

  def solve_part_two
    password = 0
    pointer = 50

    @input.each do |dial|
      dial.abs.times do
        pointer = dial.negative? ? (pointer - 1) : (pointer + 1)
        if pointer == -1
          pointer = 99
        elsif pointer == 100
          pointer = 0
        end

        password += 1 if pointer == 0
      end
    end

    password
  end
end

Solution.process_args
