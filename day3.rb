ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".freeze

def input
  @input ||= File.read("input/03.txt").split("\n")
end

def day_3_1
    input.reduce(0) do |sum, rucksack|
        slice1, slice2 = rucksack.chars.each_slice(rucksack.size / 2).map(&:join)
        duplicate = slice1.chars.intersection(slice2.chars).first
        sum += ALPHABET.index(duplicate) + 1
    end
end

def day_3_2
    input.each_slice(3).reduce(0) do |sum, elf_group|
        badge = elf_group[0].chars.intersection(elf_group[1].chars, elf_group[2].chars).first
        sum += ALPHABET.index(badge) + 1
    end
end

if __FILE__ == $0
    puts day_3_1
    puts day_3_2
end