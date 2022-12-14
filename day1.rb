class Array
  def [](index)
    at(index) || 0
  end
end

def input
  @input ||= File.read('input/01.txt').split("\n")
end

if __FILE__ == $0
  arr = []
  idx = 0
  input.each do |i|
    idx += 1 if i == ''

    arr[idx] += i.to_i
  end

  puts arr.max
  puts arr.max(3).sum
end
