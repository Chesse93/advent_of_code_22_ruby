MAX_SIZE = 100000
TOTAL = 70000000
NEEDED = 30000000
FIXNUM_MAX = (2**(0.size * 8 -2)-1)

def dir_tree(file)
    dir_path = []
    dir_sizes = Hash.new(0)

    file.each do |line|
        case line.split(" ")
        in ["$", "cd", ".."]
            dir_path.pop()
        in ["$", "cd", dir]
            ext = dir == '/' ? '' : "/#{dir}"
            dir_path.append("#{dir_path.join('')}#{ext}")
        in ["$", "ls"]
        in ["dir", dir_name]
        in [size_str, _]
            dir_path.each do |dir|
                dir_sizes[dir] += size_str.to_i
            end
        else
        end
    end

    pp dir_sizes

    dir_sizes
end

file = File.read("input/07.txt").split("\n")

tree = dir_tree(file)
available_space = TOTAL - tree[""]
space_to_clean = NEEDED - available_space

puts tree.inject(0) { |sum, (_, v)| v < MAX_SIZE ? v + sum : sum }
puts tree.min_by { |_, v| v > space_to_clean ? (space_to_clean-v).abs : FIXNUM_MAX }[1]