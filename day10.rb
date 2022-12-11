class String
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def black;          "\e[30m#{self}\e[0m" end
    def bg_black;       "\e[40m#{self}\e[0m" end
    def bg_gray;        "\e[47m#{self}\e[0m" end
    def underline;      "\e[4m#{self}\e[24m" end
end

def input
  @input ||= File.read("input/10.txt").split("\n")
end

def calculate_values(x:, y: nil, signal_strength:, cycle:)
    # puts "x: #{x}, y: #{y}, signal_strength: #{signal_strength}, cycle: #{cycle}"

    2.times do
        if (cycle % 40).zero?
            print " ".bg_black
        end

        print (cycle % 40 - x).abs < 2 ? "#".red.bg_black : ".".green

        cycle += 1

        if ((cycle - 20) % 40).zero?
            signal_strength += x * cycle 
        end


        if (cycle % 40).zero?
            print " ".bg_black
            puts 
        end

        y.nil?&&break
    end

    x += y.to_i

    [x, signal_strength, cycle]
end

def print_black_line
    42.times { print " ".bg_black }
    puts
end


def run_programm
    x,cycle,signal_strength=1,0,0;

    print_black_line

    input.each_with_index do |instruction, index|
        break if cycle > 240

        x, signal_strength, cycle = 
            case instruction.split(" ")
            in ['addx', y]
                calculate_values(x: x, y: y, cycle: cycle, signal_strength: signal_strength)
            else
                calculate_values(x: x, cycle: cycle, signal_strength: signal_strength)
            end
    end

    print_black_line

    signal_strength
end

if __FILE__ == $0
    puts "SUM: #{run_programm}".underline.black
end