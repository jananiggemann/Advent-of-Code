# --- Day 5: Cafeteria ---

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
    10.times do
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
    blank_line_id = @input.find_index("")
    fresh_id_ranges = get_cleaned_fresh_id_ranges(blank_line_id)
    available_ingredients = @input[blank_line_id+1..].map(&:to_i).sort
    fresh_ingredients = 0

    available_ingredients.each do |ingredient|
      found_range = fresh_id_ranges.find { |range| range.first <= ingredient && range.last >= ingredient }
      if found_range
        fresh_ingredients += 1
      end
    end

    fresh_ingredients
  end

  def get_cleaned_fresh_id_ranges(blank_line_id = nil)
    blank_line_id = blank_line_id || @input.find_index("")
    fresh_id_ranges = @input[0, blank_line_id].map{ |range| range.split("-").map(&:to_i) }.sort

    loop do
      start_size = fresh_id_ranges.size
      fresh_id_ranges = decrease_id_ranges(fresh_id_ranges)

      break unless start_size > fresh_id_ranges.size
    end

    fresh_id_ranges
  end

  def decrease_id_ranges(id_ranges)
    id_ranges.each_with_index do |range, i|
      next if i == 0

      if range.first <= id_ranges[i-1][1]
        id_ranges[i-1][1] = [id_ranges[i-1][1], range.last].max
        id_ranges.delete_at(i)
      end
    end
    id_ranges
  end

########## PART 2

  def solve_part_two
    fresh_id_ranges = get_cleaned_fresh_id_ranges
    fresh_ingredient_ids = 0

    fresh_id_ranges.each do |id_range|
      fresh_ingredient_ids = fresh_ingredient_ids + id_range[1] - id_range[0] + 1
    end

    fresh_ingredient_ids
  end
end

Solution.process_args
