ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".freeze

def day_3_1(rucksacks)
    rucksacks.reduce(0) do |sum, rucksack|
        slice1, slice2 = rucksack.chars.each_slice(rucksack.size / 2).map(&:join)
        duplicate = slice1.chars.intersection(slice2.chars).first
        sum += ALPHABET.index(duplicate) + 1
    end
end

def day_3_2(rucksacks)
    rucksacks.each_slice(3).reduce(0) do |sum, elf_group|
        badge = elf_group[0].chars.intersection(elf_group[1].chars, elf_group[2].chars).first
        sum += ALPHABET.index(badge) + 1
    end
end

file = File.read("input/03.txt").split("\n")

puts day_3_1(file)
puts day_3_2(file)