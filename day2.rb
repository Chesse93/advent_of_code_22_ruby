def day_2_1(file)
    round = { AX: 4, AY: 8, AZ: 3, BX: 1, BY: 5, BZ: 9, CX: 7, CY: 2, CZ: 6 }

    game_logic(file, round)
end

def day_2_2(file)
    round = { AX: 3, AY: 4, AZ: 8, BX: 1, BY: 5, BZ: 9, CX: 2, CY: 6, CZ: 7 }

    game_logic(file, round)
end

def game_logic(file, round)
    file.sum do |line|
        clean_line = line.gsub(/\s+/, "").to_sym
        round[clean_line]
    end
end


file = File.read("input/02.txt").split("\n")

puts day_2_1(file)
puts day_2_2(file)