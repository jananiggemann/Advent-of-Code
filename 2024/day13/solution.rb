# --- Day 13: Claw Contraption ---

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
    input = @input.each_slice(4).to_a
    input.each{ |s| s.delete("") }

    tokens_spend = 0

    input.each do |configuration|
      tokens_spend += check(configuration)
      puts tokens_spend
    end

    tokens_spend
  end

  def check(configuration)
    a_units = configuration[0].scan(/(\d+)/).flatten
    b_units = configuration[1].scan(/(\d+)/).flatten
    prize = configuration[2].scan(/(\d+)/).flatten

    x = x_berechnen(a_units[0].to_i, b_units[0].to_i, prize[0].to_i)
    y = y_berechnen(a_units[1].to_i, b_units[1].to_i, prize[1].to_i)

    matches = x.select { |x| x if y.include?(x) }

    return 0 if matches.size == 0

    return (matches.first[0]*3) + (matches.first[1]) if matches.size == 1

    min = ((matches.first[0]*3) + (matches.first[1]))

    matches.each do |match|
      if ((match[0]*3) + (match[1])) < min
        min = ((match[0]*3) + (match[1]))
      end
    end
    min
  end

  def x_berechnen(x_a, x_b, x_prize)
    min = x_prize
    all = []

    101.times do |a|
      if ((x_prize - (a * x_a)) % (x_b) == 0) && ((x_prize - (a * x_a)) / (x_b)) <= 100
        all << [a, ((x_prize - (a * x_a)) / (x_b)) ]

        if (((x_prize - (a * x_a)) / (x_b)))+a < min[0]+min[1]
          min = [a, ((x_prize - (a * x_a)) / (x_b))]
        end
      end
    end

    all
  end

  def y_berechnen(y_a, y_b, y_prize)
    min = y_prize
    all = []

    101.times do |a|
      if ((y_prize - (a * y_a)) % (y_b) == 0) && ((y_prize - (a * y_a)) / (y_b)) <= 100
        all << [a, ((y_prize - (a * y_a)) / (y_b)) ]

        if ((y_prize - (a * y_a)) / (y_b))+a < min[0]+min[1]
          min = [a, ((y_prize - (a * y_a)) / (y_b))]
        end
      end
    end

    all
  end

########## PART 2

  def solve_part_two
    input = @input.each_slice(4).to_a
    input.each{ |s| s.delete("") }

    tokens_spent = 0

    input.each_with_index do |configuration, i|
      tokens_spent += check2(configuration)
    end

    tokens_spent
  end

  def check2(configuration)
    a_units = configuration[0].scan(/(\d+)/).flatten
    b_units = configuration[1].scan(/(\d+)/).flatten
    prize = configuration[2].scan(/(\d+)/).flatten

    lgs = gleichungssystem(a_units[0].to_i,
                           a_units[1].to_i,
                           b_units[0].to_i,
                           b_units[1].to_i,
                           prize[0].to_i+10000000000000,
                           prize[1].to_i+10000000000000)

    if lgs[0] > 0 && lgs[1] > 0
      return (lgs[0]*3) + (lgs[1])
    end
    0
  end

  def gleichungssystem(x_a, y_a, x_b, y_b, x_prize, y_prize)
    i = [x_a*y_a, x_b*y_a, x_prize*y_a]
    ii = [y_a*x_a, y_b*x_a, y_prize*x_a]

    i_2 = [i[1]-ii[1], i[2]-ii[2]]

    return [0,0] if (i_2[0] == 0) && (i_2[1] != 0)

    if (i_2[0] != 0)
      return [0,0] unless (i_2[1] % i_2[0]) == 0
      b = i_2[1]/i_2[0]

      return [0,0] unless ((x_prize - (x_b*b)) % x_a) == 0
      a = (x_prize - (x_b*b)) / x_a
      [a, b]

    else
      list = []
      (x_prize/x_b).times do |b|
        (x_prize/x_a).times do |a|
          if b.to_f == ((x_prize - (x_a*a) ).to_f / x_b)
            list << [a, b]
          end
        end
      end

      min = []
      list.each do |l|
        if l[0] >= 0 && l[1] >= 0
          min = l if ((l[0]*3) + l[1]) < ((min[0]*3) + min[1])
        end
      end

      return min unless min.empty?
      [0, 0]
    end
  end
end

Solution.process_args
