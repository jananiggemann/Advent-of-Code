def solve_part_1
  lists = get_lists
  left_list = lists.first.sort
  right_list = lists.last.sort

  return distances(left_list, right_list).sum
end

def get_lists
  left = []
  right = []

  File.open('input.txt').each do |line|
    left << line.match(" ").pre_match.to_i
    right << line.match(" ").post_match.to_i
  end

  return [left, right]
end

def distances(left, right)
  left.map.each_with_index { | val, i | (val - right[i]).abs }
end

def solve_part_2
  lists = get_lists

  return calculate_similariy_score(lists.first, lists.last).sum
end

def calculate_similariy_score(left, right)
  appearances = right.tally

  left.map { | num | num * (appearances[num] || 0) }
end

puts("Result Part One: ", solve_part_1)
puts("Result Part Two: ", solve_part_2)
