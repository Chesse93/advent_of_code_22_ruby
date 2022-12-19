ROCKS = {
  # ####
  1 => {
    points: [
      ->(x, y) { [y, x] },
      ->(x, y) { [y, x + 1] },
      ->(x, y) { [y, x + 2] },
      ->(x, y) { [y, x + 3] }
    ],
    width: 4,
    height: 1
  },
  # .#.
  # ###
  # .#.
  2 => {
    points: [
      ->(x, y) { [y, x + 1] },
      ->(x, y) { [y + 1, x] },
      ->(x, y) { [y + 1, x + 1] },
      ->(x, y) { [y + 1, x + 2] },
      ->(x, y) { [y + 2, x + 1] }
    ],
    width: 3,
    height: 3
  },
  # ..#
  # ..#
  # ###
  3 => {
    points: [
      ->(x, y) { [y, x] },
      ->(x, y) { [y, x + 1] },
      ->(x, y) { [y, x + 2] },
      ->(x, y) { [y + 1, x + 2] },
      ->(x, y) { [y + 2, x + 2] }
    ],
    width: 3,
    height: 3
  },
  # #
  # #
  # #
  # #
  4 => {
    points: [
      ->(x, y) { [y, x] },
      ->(x, y) { [y + 1, x] },
      ->(x, y) { [y + 2, x] },
      ->(x, y) { [y + 3, x] }
    ],
    width: 1,
    height: 4
  },
  # ##
  # ##
  5 => {
    points: [
      ->(x, y) { [y, x] },
      ->(x, y) { [y, x + 1] },
      ->(x, y) { [y + 1, x] },
      ->(x, y) { [y + 1, x + 1] }
    ],
    width: 2,
    height: 2
  }
}.freeze

JETDIR = { '<' => -1, '>' => 1 }.freeze
ROCKS_COUNT = 2023
WINDOW_SIZE = 100
WINDOW_ADJUSTMENT = 10

def input
  @input ||= File.read('input/17.txt').chars
end

def get_grid_points(x, y, rock_type)
  points = []
  ROCKS[rock_type][:points].each do |point|
    points << point.call(x, y)
  end
  points
end

def grid
  @grid ||= Array.new(WINDOW_SIZE + WINDOW_ADJUSTMENT) { Array.new(7) { '+' } }
end

def jets
  @jets ||= input.map { JETDIR[_1] }.compact
end

def move_grid_slide(sum_biggest_height, biggest_height, last_biggest_height)
  sum_biggest_height += (biggest_height - last_biggest_height)
  biggest_height -= WINDOW_ADJUSTMENT
  last_biggest_height = biggest_height
  10.times { grid << Array.new(7) { '+' } }
  10.times { grid.shift }

  [sum_biggest_height, biggest_height, last_biggest_height]
end

def day_17_1
  sum_biggest_height = 0
  last_biggest_height = 0
  biggest_height = 0
  moves = 0
  (1..ROCKS_COUNT).each do |count|
    rock_type = (count % 5).zero? ? 5 : count % 5
    at_rest = false
    x = 2

    if biggest_height >= WINDOW_SIZE
      sum_biggest_height, last_biggest_height, biggest_height = move_grid_slide(sum_biggest_height, biggest_height,
                                                                                last_biggest_height)
    end

    y = biggest_height + 3

    until at_rest
      rock_points = get_grid_points(x, y, rock_type)
      rock_points.each do |rock_point|
        grid[rock_point[0]][rock_point[1]] = '#'
      end
      # move left or right
      new_x = x + (moves.zero? ? jets[0] : jets[moves % jets.size])
      check = !new_x.negative? && (new_x + ROCKS[rock_type][:width]) <= 7
      move = true
      if check
        lr_rock_points = get_grid_points(new_x, y, rock_type)
        (lr_rock_points - rock_points).each do |rock_point|
          next unless move

          move = false if grid[rock_point[0]][rock_point[1]] == '#'
        end
        if move
          x = new_x
          rock_points.each do |rock_point|
            grid[rock_point[0]][rock_point[1]] = '+'
          end
          rock_points = lr_rock_points
          rock_points.each do |rock_point|
            grid[rock_point[0]][rock_point[1]] = '#'
          end
        end
      end

      # move down
      new_y = y - 1
      move = true
      if new_y.negative?
        biggest_height = y + ROCKS[rock_type][:height] if y + ROCKS[rock_type][:height] > biggest_height
        move = false
        at_rest = true
        moves += 1
        break
      end
      d_rock_points = get_grid_points(x, new_y, rock_type)
      (d_rock_points - rock_points).each do |rock_point|
        next unless move

        move = false if grid[rock_point[0]][rock_point[1]] == '#'
      end
      if move
        y = new_y
        rock_points.each do |rock_point|
          grid[rock_point[0]][rock_point[1]] = '+'
        end
        rock_points = d_rock_points
        rock_points.each do |rock_point|
          grid[rock_point[0]][rock_point[1]] = '#'
        end
      else
        at_rest = true
      end

      biggest_height = y + ROCKS[rock_type][:height] if at_rest && (y + ROCKS[rock_type][:height] > biggest_height)

      moves += 1
    end
    sum_biggest_height += (biggest_height - last_biggest_height) if count == ROCKS_COUNT - 1
  end
  sum_biggest_height
end

if __FILE__ == $0
  puts day_17_1
  puts ''
end
