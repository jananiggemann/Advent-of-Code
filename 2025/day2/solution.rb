# --- Day 2: Gift Shop ---

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
    input = @input.first.split(",")
    summed_invalid_ids = 0

    input.each do |range|
      range = range.split("-")
      ids = (range.first..range.last).to_a
      ids.delete_if{ |id| id.length.odd? }
      ids.each do |id|
        summed_invalid_ids += id.to_i if id[...id.length/2] == id[id.length/2..]
      end
    end

    summed_invalid_ids
  end

########## PART 2

  def solve_part_two
    input = @input.first.split(",")
    summed_invalid_ids = 0

    input.each do |range|
      range = range.split("-")
      ids = (range.first..range.last).to_a

      ids.each do |id|
        uniq_count = id.split("").uniq.count
        next if uniq_count == id.length

        summed_invalid_ids += check_for_sequences(id, uniq_count)
      end
    end

    summed_invalid_ids
  end

  def check_for_sequences(id, uniq_count)
    max = id.length.odd? ? id.length/3 : id.length/2

    (uniq_count..max).each do |partitition|
      next unless id.length % partitition == 0

      potential_sequences = id.scan(/.{1,#{partitition}}/)
      return id.to_i if potential_sequences.uniq.count == 1
    end
    0
  end
end

Solution.process_args
