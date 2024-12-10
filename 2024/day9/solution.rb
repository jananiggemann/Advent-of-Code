# --- Day 9: Disk Fragmenter ---

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
    start_time = Time.now
    puts("Part One: ", solve_part_one)
    puts "Execution time: #{Time.now-start_time} seconds"
    start_time = Time.now
    puts("Part Two: ", solve_part_two)
    puts "Execution time: #{Time.now-start_time} seconds"
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
    blocks = @input.map { |line| line.split("").map!(&:to_i) }.flatten

    blocks.map!.with_index do |block, index|
      if index%2 == 0
        Array.new(block, index/2)
      else
        Array.new(block, nil)
      end
    end.flatten!

    calculate_checksum(compact_filesystem(blocks))
  end

  def compact_filesystem(blocks)
    blocks.pop while blocks.last.nil?

    while blocks.include?(nil)
      blocks[blocks.index(nil)] = blocks.pop
      blocks.pop while blocks.last.nil?
    end
    blocks
  end

  def calculate_checksum(filesystem)
    filesystem.map.with_index do |file, i|
      if file
        file*i
      else
        0
      end
    end.sum
  end

########## PART 2

  def solve_part_two
    blocks = @input.dup
    blocks = blocks.map { |line| line.split("").map!(&:to_i) }.flatten
    spaces = {}

    i = 0
    blocks.map!.with_index do |block, index|
      if index%2 == 0
        i += block
        Array.new(block, index/2)
      else
        spaces[i] = block
        i += block
        Array.new(block, nil)
      end
    end.flatten!

    remaining_blocks = blocks.tally
    remaining_blocks.delete(nil)

    filesystem = compact_filesystem2(blocks, spaces, remaining_blocks)
    calculate_checksum(filesystem)
  end

  def compact_filesystem2(blocks, spaces, remaining)
    remaining = remaining.sort.reverse.to_h

    remaining.each do |block_index, block_size|
      current_position = blocks.index(block_index)

      return blocks if spaces.empty? || current_position < spaces.keys.first

      index_of_space, space_size = spaces.find do |key, value|
        value >= block_size  && key < current_position
      end

      if index_of_space
        blocks.map! { |b| b == block_index ? nil : b }

        block_size.times do |i|
          blocks[index_of_space + i] = block_index
        end

        if space_size > block_size
          spaces[index_of_space + block_size] = space_size - block_size
        end
        spaces.delete(index_of_space)
      end
      spaces.reject!{ |k, _| k > current_position }
      spaces = spaces.sort.to_h
    end

    blocks
  end
end

Solution.process_args
