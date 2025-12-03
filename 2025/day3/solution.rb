# --- Day 3: Lobby---

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
    2.times do
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
    total_output_joltage = 0

    @input.each do |bank|
      bank = bank.split("").map(&:to_i)
      max1 = [0, 0]
      max2 = 0

      bank[0, bank.length-1].each_with_index do |batterie, i|
        max1 = [batterie, i] if batterie > max1.first
      end

      bank[max1.last+1, bank.length-1].each do |batterie|
        max2 = batterie if batterie > max2
      end

      total_output_joltage += [max1[0], max2].join.to_i
    end
    total_output_joltage
  end

########## PART 2

  def solve_part_two
    total_output_joltage = 0

    @input.each do |bank|
      bank = bank.split("").map(&:to_i)
      voltage = []

      (0..11).to_a.reverse.each do |i|
        window = bank.length-i
        next_max = get_max(bank[0, window])
        voltage.push(next_max.first)
        bank = bank.drop(next_max.last+1)
      end
      total_output_joltage += voltage.join.to_i
    end
    total_output_joltage
  end

  def get_max(bank)
    max = [0, 0]
    bank.each_with_index do |batterie, i|
      max = [batterie, i] if batterie > max.first
    end
    max
  end
end

Solution.process_args
