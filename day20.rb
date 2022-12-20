class Number
  attr_accessor :value

  def initialize(value)
    @value = value
  end
end

DECRIPTION_KEY = 811_589_153

def input
  @input ||= File.read('input/20.txt').split("\n")
end

def numbers
  @numbers ||= input.map { |e| Number.new(e.to_i) }
end

def multiplied_numbers
  @multiplied_numbers ||= numbers.each { |e| e.value *= DECRIPTION_KEY }
end

def move_numbers(number, final_numbers)
  index = final_numbers.index(number)
  final_numbers.delete_at(index)
  new_index = index + number.value
  new_index %= final_numbers.size
  final_numbers.insert(new_index, number)
end

def mixing_numbers(final_numbers, used_numbers)
  used_numbers.each { move_numbers(_1, final_numbers) }
end

def get_grove_coordinates(final_numbers)
  zero_index = final_numbers.index { _1.value.zero? }

  [1000, 2000, 3000].map { |i| final_numbers[(zero_index + i) % final_numbers.size].value }.sum
end

def day_20_1
  final_numbers = numbers.clone

  mixing_numbers(final_numbers, numbers)

  get_grove_coordinates(final_numbers)
end

def day_20_2
  final_numbers = multiplied_numbers.clone

  10.times { mixing_numbers(final_numbers, multiplied_numbers) }

  get_grove_coordinates(final_numbers)
end

if __FILE__ == $0
  puts "Sum of the three numbers that form the grove coordinates: #{day_20_1}"
  puts "Sum of the three numbers that form the grove coordinates with decryption key #{DECRIPTION_KEY}: #{day_20_2}"
end
