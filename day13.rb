require 'json'

def input
     @input ||= File.read('input/13.txt').split("\n")
end

def dividers
    [[2],[6]]
end

def pairs
    @parsed_input ||= input.reject { _1 == "" }.map { JSON.parse(_1) }
end

def compare(left, right)
    # puts "compare => x: #{left} y: #{right}"
    # sleep(0.1)
    case [left, right]
    in [Integer, Integer]
        left <=> right
    in [Array, Array]
        min_size = [left.size, right.size].min
        (0...min_size).each do |idx|
            result = compare(left[idx], right[idx])
            return result if result != 0
        end
        left.size <=> right.size
    else # [Array, Integer] | [Integer, Array]
        compare([left].flatten(1), [right].flatten(1))
    end
end

def calculate_right_ordered_indice_sum
    sum = 0

    pairs.each_slice(2).with_index do |(left, right), index| 
        compared_value = compare(left, right)
        pair = index + 1
        # puts "pair: #{pair}, compared: #{compared_value == -1 ? "right order" : "wrong order"}, left: #{left} right: #{right}"
        sum += (pair) if compared_value == -1
    end

    sum
end

def calculate_decoder_key
    all_pairs = pairs + dividers
    sorted = all_pairs.sort(&method(:compare))
    dividers.map { sorted.find_index(_1) + 1 }.inject(&:*)
end

if __FILE__ == $0
    puts "Sum of the indices: #{calculate_right_ordered_indice_sum}"
    puts "Decoder key: #{calculate_decoder_key}"
end