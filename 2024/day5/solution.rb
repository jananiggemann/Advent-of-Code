# --- Day 5: Print Queue ---

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
    rules = @input[0...@input.index("")]
    updates = @input[@input.index("")+1..]

    rules.map! { |r| r.split("|").map(&:to_i) }
    updates.map! { |u| u.split(",").map(&:to_i) }

    result = 0
    updates.each do |update|
      result += check_update(update, rules)
    end
    result
  end

  def check_update(update, rules)
    rules = get_rules_for_update(update, rules)

    correct_order = update.each_with_index.all? do |page, i|
      update[0...i].all? do |u|
        !get_rules_for_page(u, rules).include?([page, u])
      end
    end

    return update[(update.size/2).floor] if correct_order
    0
  end

  def get_rules_for_update(update, rules)
    rules.select do |rule|
      update.include?(rule[0]) && update.include?(rule[1])
    end
  end

  def get_rules_for_page(page, rules)
    rules.select do |rule|
      rule.include?(page)
    end
  end

########## PART 2

  def solve_part_two
    rules = @input[0...@input.index("")]
    updates = @input[@input.index("")+1..]

    rules.map! { |r| r.split("|").map(&:to_i) }
    updates.map! { |u| u.split(",").map(&:to_i) }

    result = 0
    updates.each do |update|
      result += get_fixed_page_number(update, rules)
    end
    result
  end

  def get_fixed_page_number(update, rules)
    rules = get_rules_for_update(update, rules)

    correct_order = update.each_with_index.all? do |page, i|
      update[0...i].all? do |u|
        !get_rules_for_page(u, rules).include?([page, u])
      end
    end

    if !correct_order
      update = fix_update(update, rules)
      return update[(update.size/2).floor]
    end
    0
  end

  def fix_update(update, rules)
    update.each_with_index do |page, i|
      update[0...i].each_with_index do |u, j|
        if get_rules_for_page(u, rules).include?([page, u])
          update.insert(j, page)
          update.delete_at(i+1)
          break
        end
      end
    end
  end
end

Solution.process_args
