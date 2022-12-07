class Array         
  def [](index)
     self.at(index) ? self.at(index) : 0
  end
end

file = File.read("input/01.txt")

arr = []
idx = 0
file.split("\n").each do |i|
    if i == ""
        idx += 1
    end

    arr[idx] += i.to_i
end

puts arr.max
puts arr.max(3).sum