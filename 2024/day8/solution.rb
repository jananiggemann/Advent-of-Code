# --- Day 8: Resonant Collinearity ---

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
    map = @input.dup
    frequencies = multi_frequencies(all_frequencies(map))

    antidotes(frequencies, map)
  end

  def all_frequencies(input)
    frequencies = []
    input.each do |line|
      frequencies << line.scan(/\w/)
    end
    frequencies
  end

  def multi_frequencies(frequencies)
    count = frequencies.flatten.tally

    frequencies.map! do |line|
      line.map { |frequency| frequency if count[frequency] >= 2 }
    end
  end

  def antidotes(frequencies, map)
    antennas = frequencies.flatten.tally
    indices = []
    width = map.first.size
    flat = map.join

    antennas.each do |frequency, amount|
      frequency_indices = []
      flat.each_char.with_index do |field, i|
        if field == frequency
          frequency_indices << i
        end
      end

      frequency_indices.combination(2).each do |pair|
        last = pair.first
        new = pair.last

        distance = new-last

        last_row = last/width
        last_i = last%width

        new_row = new/width
        new_i = new%width

        if last_i < new_i
          i_before = last_i - (new_i - last_i)
          i_next = new_i + (new_i - last_i)
        elsif last_i > new_i
          i_before = last_i + (last_i - new_i)
          i_next = new_i - (last_i - new_i)
        else
          i_before = last_i
          i_next = new_i
        end

        #before
        if distance <= last
          stelle = (last-distance)%width
          reihe = (last-distance)/width

          if last_row == new_row && new_row == reihe && i_before == stelle
            indices << (reihe) * width + stelle
          elsif stelle == i_before && reihe == last_row - (new_row - last_row)
            indices << (reihe) * width + stelle
          end
        end

        #next
        if (new + distance) < flat.size
          stelle = (new+distance)%width
          reihe = (new+distance)/width

          if last_row == new_row && new_row == reihe && i_next == stelle
            indices << (reihe) * width + stelle
          elsif stelle == i_next && reihe == new_row + (new_row - last_row)
            indices << (reihe) * width + stelle
          end
        end

      end
    end
    indices.uniq.count
  end

########## PART 2

  def solve_part_two
    map = @input.dup
    frequencies = all_frequencies(map)
    frequencies = multi_frequencies(frequencies)

    antidotes2(frequencies, map)
  end

  def antidotes2(frequencies, map)
    antennas = frequencies.flatten.tally
    indices = []
    flat = map.join

    antennas.each do |frequency, amount|
      frequency_indices = []
      flat.each_char.with_index do |field, i|
        frequency_indices << i if field == frequency
      end

      frequency_indices.combination(2).each do |pair|
        last = pair.first
        new = pair.last
        frequency_indices = loop1(last, new, frequency_indices, map.first.size, flat)
      end
      indices = indices + frequency_indices.uniq.sort!
    end

    indices.uniq.count
  end

  def loop1(last, new, indices, width, flat)
    distance = new-last
    return indices if distance <= 0

    last_row = last/width
    last_i = last%width

    new_row = new/width
    new_i = new%width

    if last_i < new_i
      i_before = last_i - (new_i - last_i)
      i_next = new_i + (new_i - last_i)
    elsif last_i > new_i
      i_before = last_i + (last_i - new_i)
      i_next = new_i - (last_i - new_i)
    else
      i_before = last_i
      i_next = new_i
    end

    #before
    if last-distance >= 0 && last-distance < flat.size
      stelle = (last-distance)%width
      reihe = (last-distance)/width

      if last_row == new_row && new_row == reihe && i_before == stelle
        i = [(reihe) * width + stelle]
        if !indices.include?(i.last)
          indices = indices + i + loop1(i.last, last, indices+i, width, flat)
        end
      elsif stelle == i_before && reihe == last_row - (new_row - last_row)
        i = [(reihe) * width + stelle]
        if !indices.include?(i.last)
          indices = indices + i + loop1(i.last, last, indices+i, width, flat)
        end
      end
    end

    #next
    if new+distance >= 0 && new+distance < flat.size
      stelle = (new+distance)%width
      reihe = (new+distance)/width

      if last_row == new_row && new_row == reihe && i_next == stelle
        j = [(reihe) * width + stelle]
        if !indices.include?(j.last)
          indices = indices + j + loop1(new, j.last, indices+j, width, flat)
        end
      elsif stelle == i_next && reihe == new_row + (new_row - last_row)
        j = [(reihe) * width + stelle]
        if !indices.include?(j.last)
          indices = indices + j + loop1(new, j.last, indices+j, width, flat)
        end
      end
    end

    indices.uniq.sort!
  end
end

Solution.process_args
