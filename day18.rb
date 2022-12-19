def input = @input ||= File.read('input/18.txt').split("\n")

def coordinates_to_string(vec) = vec.join(':')

def cubes = @cubes ||= parse_cubes

def parse_cubes
  h = {}

  input.each do |line|
    vec = line.split(',').map(&:to_i)
    h[coordinates_to_string(vec)] = vec
  end

  h
end

def adj(x, y, z)
  [
    [x, y, z + 1],
    [x, y, z - 1],
    [x, y + 1, z],
    [x, y - 1, z],
    [x + 1, y, z],
    [x - 1, y, z]
  ]
end

def faces(x, y, z)
  adj(x, y, z).map { |vec| coordinates_to_string(vec) }
end

def day_18_1
  cubes.values.inject(0) do |sum, (x, y, z)|
    faces(x, y, z).inject(sum) { |sub_sum, key| cubes[key].nil? ? sub_sum += 1 : sub_sum }
  end
end

if __FILE__ == $0
  puts day_18_1
  puts ''
end
