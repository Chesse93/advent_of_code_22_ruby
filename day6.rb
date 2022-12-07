def self.find_unique_string(str, length)
  str.chars
    .each_cons(length)
    .find_index { |chars| chars.uniq.length == length }
    .then { _1 + length }
end

file = File.read("input/06.txt")

puts find_unique_string(file, 4)
puts find_unique_string(file, 14)