require 'set'

def input
  @input ||= File.read("input/09.txt").split("\n")
end

def move(position, direction)
    case direction
    when "R"
        position[:x] += 1
    when "L"
        position[:x] -= 1
    when "U"
        position[:y] += 1
    when "D"
        position[:y] -= 1
    end

    position
end

def move_tail(tail, head)
    should_move = ((tail[:x] - head[:x]).abs > 1) || ((tail[:y] - head[:y]).abs > 1)

    return tail unless should_move

    if head[:x] > tail[:x]
        tail = move(tail, "R")
    elsif head[:x] < tail[:x]
        tail = move(tail, "L")
    end

    if head[:y] > tail[:y]
        tail = move(tail, "U")
    elsif head[:y] < tail[:y]
        tail = move(tail, "D")
    end

    tail
end

def count_tails_visited_positions(tail_length = 1)
    start = {x: 0, y: 0}
    visited = Set[]

    head = start.clone
    tail = Array.new(tail_length) { start.clone }

    input.each do |line|
        direction, steps = line.split(" ")
        steps.to_i.times do
            head = move(head, direction)
            last_position = head.clone

            tail.each_with_index do |tail_part, idx|
                tail[idx] = move_tail(tail_part, last_position)
                last_position = tail_part.clone
            end

            visited.add(tail[-1].clone)
        end

        # puts "Move: #{line}, Head: #{head}, Tail: #{tail}"
    end

    visited.length
end

if __FILE__ == $0
  puts count_tails_visited_positions
  puts count_tails_visited_positions(9)
end