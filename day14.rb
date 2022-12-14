require 'benchmark'

FIXNUM_MAX = (2**(0.size * 8 - 2) - 1)
FIXNUM_MIN = -(2**(0.size * 8 - 2))

def input
  @input ||= File.read('input/14.txt').split("\n")
end

def highest_x
  @highest_x ||= FIXNUM_MIN
end

def set_highest_x(x)
  @highest_x = x if x > highest_x
end

def highest_y
  @highest_y ||= FIXNUM_MIN
end

def set_highest_y(y)
  @highest_y = y if y > highest_y
end

def initialize_map
  points = input.map do |line|
    line.split(' -> ').map do |pt|
      (x, y) = pt.split(',').map(&:to_i)

      set_highest_x(x)
      set_highest_y(y)

      { x: x, y: y }
    end
  end

  map = Array.new(highest_y + 3) { Array.new(highest_x) { '.' } }

  points.each do |point_line|
    point_line.each_index do |idx|
      break if idx == point_line.length - 1

      point1 = point_line[idx]
      point2 = point_line[idx + 1]

      x_range = point1[:x] > point2[:x] ? (point2[:x]..point1[:x]) : (point1[:x]..point2[:x])
      y_range = point1[:y] > point2[:y] ? (point2[:y]..point1[:y]) : (point1[:y]..point2[:y])

      y_range.each { |y| map[y][point1[:x]] = 1 } if point1[:x] == point2[:x]
      x_range.each { |x| map[point1[:y]][x] = 1 } if point1[:y] == point2[:y]
    end
  end

  map[0][500] = '+'

  map
end

def initialized_map
  @initialized_map ||= initialize_map
end

def drop_sand(x, y)
  return [nil, nil] if x >= highest_x || y >= highest_y + 1

  if initialized_map[y + 1][x] == '.'
    initialized_map[y][x] = '.'
    initialized_map[y + 1][x] = '+'
    return drop_sand(x, y + 1)
  end

  if initialized_map[y + 1][x - 1] == '.'
    initialized_map[y][x] = '.'
    initialized_map[y + 1][x - 1] = '+'
    return drop_sand(x - 1, y + 1)
  end

  return [x, y] unless initialized_map[y + 1][x + 1] == '.'

  initialized_map[y][x] = '.'
  initialized_map[y + 1][x + 1] = '+'
  drop_sand(x + 1, y + 1)
end

# can be used to print the map on large screens
def print_map
  system 'clear'
  initialized_map.each_with_index do |row, _xi|
    row.each_with_index do |cell, _yi|
      print cell.to_s
    end
    puts
  end
end

def day_14_1
  initialized_map
  largest_y = 0

  loop.with_index do |_, _num|
    _, y = drop_sand(500, 0)
    if y.nil?
      # puts "#{num} units of sand come to rest before sand starts flowing into the abyss below"
      break
    elsif y > largest_y
      largest_y = y
    end
  end
end

def day_14_2
  highest_x.times do |num|
    initialized_map[-1][num] = '#'
  end

  loop.with_index do |_, num|
    x, y = drop_sand(500, 0)
    if x == 500 && y.zero?
      puts "#{num + 1} units of sand come to rest"
      break
    end
  end
end

if __FILE__ == $0
  Benchmark.bm(10) do |x|
    x.report('Day 14_1:') { day_14_1 }
    x.report('Day 14_2:') do
      @initialized_map = nil
      @highest_x = 700 # cause normal array is to small
      day_14_2
    end
  end
end
