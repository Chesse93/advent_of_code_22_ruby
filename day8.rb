def input
  @input ||= File.read('input/08.txt')
end

def forest
  @forest ||= input.split("\n").map { _1.chars.each(&:to_i) }
end

def forest_transposed
  @forest_transposed ||= forest.transpose
end

def shorter?(tree_row, tree)
  tree_row.max < tree
end

def calc_scenic_score_for_direction(tree_row, tree)
  a = tree_row.inject(0) do |sum, i|
    sum += 1
    break sum if i >= tree

    sum
  end
end

def maybe_set_new_scenic_score(old_scenic_score, trees_scenic_score)
  old_scenic_score > trees_scenic_score ? old_scenic_score : trees_scenic_score
end

def walk_through_the_forest
  forest[1..-2].each_index do |i|
    i += 1
    forest[1..-2].each_index do |j|
      j += 1

      current_tree = forest[i][j]

      left_part = forest[i][0..j - 1]
      right_part = forest[i][j + 1..-1]
      up_part = forest_transposed[j][0..i - 1]
      down_part = forest_transposed[j][i + 1..-1]
      yield(current_tree, left_part, right_part, up_part, down_part)
    end
  end
end

def count_visible_trees
  visible_trees = forest.length * 4 - 4

  walk_through_the_forest do |current_tree, left_part, right_part, up_part, down_part|
    left = shorter?(left_part, current_tree)
    right = shorter?(right_part, current_tree)
    up = shorter?(up_part, current_tree)
    down = shorter?(down_part, current_tree)

    visible_trees += 1 if left || right || up || down
  end

  visible_trees
end

def calc_scenic_score
  scenic_score = 0

  walk_through_the_forest do |current_tree, left_part, right_part, up_part, down_part|
    left = calc_scenic_score_for_direction(left_part.reverse, current_tree)
    right = calc_scenic_score_for_direction(right_part, current_tree)
    up = calc_scenic_score_for_direction(up_part.reverse, current_tree)
    down = calc_scenic_score_for_direction(down_part, current_tree)

    scenic_score = maybe_set_new_scenic_score(scenic_score, left * right * up * down)
  end

  scenic_score
end

if __FILE__ == $0
  puts count_visible_trees
  puts calc_scenic_score
end
