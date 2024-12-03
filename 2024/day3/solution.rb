# --- Day 3: Mull It Over ---

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
    @input = @input.join unless @input.kind_of?(String)

    @input.scan(/mul\(\d+\,\d+\)/).each do | word |
      word.delete_prefix!("mul(")
      word.delete_suffix!(")")
      numbers = word.split(",")

      result += numbers[0].to_i * numbers[1].to_i
    end
    result
  end

########## PART 2

  def solve_part_two
    result = 0
    @input = @input.join unless @input.kind_of?(String)

    memory = @input.dup
    until memory.empty?
      @input = memory[0...(memory.index("don't()"))]
      result += solve_part_one

      memory = memory[(memory.index("don't()"))..]
      memory = if memory.include?("don't()") && memory.include?("do()")
                 memory[(memory.index("do()"))..]
               else
                 ""
               end
    end
    result
  end
end

Solution.process_args
