class String
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def bg_black;       "\e[40m#{self}\e[0m" end
end

def input
     @input ||= File.read('input/12.txt').split("\n")
end

def matrix(points = false)
    if points
        start_point = []
    else
        start_point = nil
    end
    end_point = nil
    matrix =
        input.each_with_index.map do |line, line_index|
            # S = 83 = Start
            # Z = 69 = End
            line.bytes.each_with_index.map do |byte, byte_index|
                if byte == 83 && !points
                    start_point = { x: line_index, y: byte_index }
                    0
                elsif byte == 83 && points && (line_index == 0 || byte_index == 0)
                    start_point << { x: line_index, y: byte_index }
                    0
                elsif byte == 97 && points && (line_index == 0 || byte_index == 0)
                    start_point << { x: line_index, y: byte_index }
                    byte - 96
                elsif byte == 69
                    end_point = { x: line_index, y: byte_index }
                    27
                else
                    byte - 96
                end
            end
        end

    [matrix, start_point, end_point]
end

def reset_matrix
    @printed_graph = nil
    @last_visited_x = nil
    @last_visited_y = nil
    sleep(0.5)
end

def print_matrix(x, y, mountain_map)
    @printed_graph ||= mountain_map.map { |line| line.map { |int| int == 0 ? "S" : int == 27 ? "E" :(int + 96).chr } }
    @max_char_width ||=  @printed_graph.map(&:first).max_by(&:size).size
    @max_width ||= mountain_map.first.length
    @last_visited_x ||= 0
    @last_visited_y ||= 0

    @printed_graph[x][y] = "x".green
    @printed_graph[@last_visited_x][@last_visited_y] = "x".red
    @last_visited_x = x
    @last_visited_y = y

    system "clear"
    print_black_line(@max_width, @max_char_width)
    @printed_graph.each do |line|
        line.each do |char|
            print " #{char.to_s.ljust(@max_char_width)} "
        end
        puts
    end
    print_black_line(@max_width, @max_char_width)
    sleep(0.05)
end

def print_black_line(size, char_width)
    size.times { print "   ".ljust(char_width).bg_black }
    puts
end

def step(x, y, mountain_map, steps, visited)
    return visited if !visited["#{x}:#{y}"].nil? && steps >= visited["#{x}:#{y}"]
    # print_matrix(x.clone, y.clone, mountain_map.clone)
    visited["#{x}:#{y}"] = steps
    current = mountain_map[x][y]
    # reset_matrix if current == 27
    return visited if current == 27

    up = (y - 1 >= 0 ? mountain_map[x][y - 1] : 30)
    down = (y + 1 <= mountain_map.first.size - 1 ? mountain_map[x][y + 1] : 30)
    left = (x - 1 >= 0 ? mountain_map[x - 1][y] : 30)
    right = (x + 1 <= mountain_map.size - 1 ? mountain_map[x + 1][y] : 30)

    visited = step(x, y - 1, mountain_map, steps + 1, visited) if up - current < 2 || (current == 25 && up == 27)
    visited = step(x, y + 1, mountain_map, steps + 1, visited) if down - current < 2 || (current == 25 && down == 27)
    visited = step(x - 1, y, mountain_map, steps + 1, visited) if left - current < 2 || (current == 25 && left == 27)
    visited = step(x + 1, y, mountain_map, steps + 1, visited) if right - current < 2 || (current == 25 && right == 27)
    visited
end

def running_up_that_hill
    visited = {}
    mountain_map, start_node, end_node = matrix

    step(start_node[:x], start_node[:y], mountain_map, 0, visited)

    visited["#{end_node[:x]}:#{end_node[:y]}"]
end

def find_best_hiking_trail
    trails = []
    mountain_map, start_nodes, end_node = matrix(true)
    start_nodes.each do |start_node|
        visited = {}
        step(start_node[:x], start_node[:y], mountain_map, 0, visited)
        trails << visited["#{end_node[:x]}:#{end_node[:y]}"]
    end

    trails.compact.min
end

if __FILE__ == $0
    puts "#{running_up_that_hill} steps needed!"
    puts "#{find_best_hiking_trail} fewest steps needed!"
end