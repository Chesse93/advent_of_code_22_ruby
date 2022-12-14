MAX_SIZE = 100_000
TOTAL = 70_000_000
NEEDED = 30_000_000
FIXNUM_MAX = (2**(0.size * 8 - 2) - 1)

def dir_tree(file)
  dir_path = []
  dir_sizes = Hash.new(0)

  file.each do |line|
    case line.split(' ')
    in ['$', 'cd', '..']
      dir_path.pop
    in ['$', 'cd', dir]
      ext = dir == '/' ? '' : "/#{dir}"
      dir_path.append("#{dir_path.join('')}#{ext}")
    in ['$', 'ls']
    in ['dir', dir_name]
    in [size_str, _]
      dir_path.each do |dir|
        dir_sizes[dir] += size_str.to_i
      end
    else
    end
  end

  dir_sizes
end

file = File.read('input/07.txt').split("\n")

tree = dir_tree(file)
available_space = TOTAL - tree['']
space_to_clean = NEEDED - available_space

# Get the sum of values under MAX_SIZE
puts tree.inject(0) { |sum, (_, v)| v < MAX_SIZE ? v + sum : sum }

# Get the nearest greater Value to space_to_clean
puts tree.min_by { |_, v| v > space_to_clean ? (space_to_clean - v).abs : FIXNUM_MAX }[1]
