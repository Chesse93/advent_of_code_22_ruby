def input
  @input ||= File.read('input/02.txt').split("\n")
end

def day_2_1(_file)
  round = { AX: 4, AY: 8, AZ: 3, BX: 1, BY: 5, BZ: 9, CX: 7, CY: 2, CZ: 6 }
  game_logic(round)
end

def day_2_2(_file)
  round = { AX: 3, AY: 4, AZ: 8, BX: 1, BY: 5, BZ: 9, CX: 2, CY: 6, CZ: 7 }
  game_logic(round)
end

def game_logic(round)
  input.sum do |line|
    clean_line = line.gsub(/\s+/, '').to_sym
    round[clean_line]
  end
end

if __FILE__ == $0
  puts day_2_1
  puts day_2_2
end
