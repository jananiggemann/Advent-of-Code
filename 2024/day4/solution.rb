# --- Day 4: Ceres Search ---

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
    rows = @input.map { |line| line.split("") }
    line_length = rows.first.count

    horizontal_strings = @input.dup

    vertical_strings = Array.new(line_length) { [] }
    vertical_strings = vertical_strings.map.with_index do |a, i|
      rows.each { |r| a << r[i] }
      a.join
    end

    anzahl_diagonalen = rows.size + line_length - 1
    diagonal_lr_strings = make_diagonal_rl_strings(rows, anzahl_diagonalen)
    diagonal_rl_strings  = make_diagonal_lr_strings(rows, anzahl_diagonalen)

    count += count_xmas(horizontal_strings)
    count += count_xmas(vertical_strings)
    count += count_xmas(diagonal_lr_strings)
    count += count_xmas(diagonal_rl_strings)
  end


  def count_xmas(rows)
    rows.sum { |row| row.scan(/(?=XMAS)/).count + row.scan(/(?=SAMX)/).count }
  end

  def make_diagonal_rl_strings(rows, anzahl_diagonalen)
    diagonal_rl_strings  = Array.new(anzahl_diagonalen) { [] }
    diagonal_rl_strings.map.with_index do |a, i|
      rows.each_with_index do |row, row_index|
        char_index = i - row_index
        if char_index >= 0 && char_index < row.size
          a << rows[row_index][char_index]
        end
      end
      a.join
    end
  end

  def make_diagonal_lr_strings(rows, anzahl_diagonalen)
    diagonal_lr_strings  = Array.new(anzahl_diagonalen) { [] }
    diagonal_lr_strings = diagonal_lr_strings.map.with_index do |a, i|
      rows.each_with_index do |row, row_index|
        char_index = i - row_index
        if char_index >= 0 && char_index < row.size
          a << rows[row_index][row.size - 1 - char_index]
        end
      end
      a.join
    end
  end

########## PART 2

  def solve_part_two
    count = 0
    rows = @input.map { |line| line.split("") }
    line_length = rows.first.count

    anzahl_diagonalen = rows.size + line_length - 1
    diagonal_rl_strings = make_diagonal_rl_strings(rows, anzahl_diagonalen)

    diagonal_rl_matches = diagonal_rl_strings.map do |str|
      mas = indices_of_matches(str, "MAS").map{ |pos| pos+1 }
      sam = indices_of_matches(str, "SAM").map{ |pos| pos+1 }
      (mas+sam).uniq
    end

    diagonal_rl_matches.each_with_index do |dia_a_positions, dia_row_index|
      dia_a_positions.each do |dia_pos|
        if dia_row_index >= rows.size
          transformed_index = rows.first.size - 1 - dia_pos
        else
          transformed_index = diagonal_rl_strings[dia_row_index].length - 1 - dia_pos
        end

        hor_row_index = dia_row_index - transformed_index

        count += check_rl_dia(hor_row_index, transformed_index, rows)
      end
    end
    count
  end

  def check_rl_dia(a_row, a_pos, rows)
    unless a_row == 0 || a_row >= rows.size-1 || a_pos == 0 || a_pos >= rows.first.size-1
      if rows[a_row-1][a_pos-1] == "M" && rows[a_row+1][a_pos+1] == "S"
        return 1
      elsif rows[a_row-1][a_pos-1] == "S" && rows[a_row+1][a_pos+1]  == "M"
        return 1
      end
    end
    0
  end

  def indices_of_matches(str, target)
    sz = target.size
    (0..str.size-sz).select { |i| str[i,sz] == target }
  end
end

Solution.process_args
