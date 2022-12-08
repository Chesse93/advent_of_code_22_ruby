def input
  @input ||= File.read("input/05.txt").split("\n\n")
end

def initial_stacks
  @initial_stacks ||= (
    input.first.
          split("\n").
          map(&:chars).
          transpose.
          select { |stack| stack.any? { |e| /\d+/.match(e) } }.
          map { |stack| *contents, number = stack; contents.delete(" "); [number.to_i, contents] }.
          to_h
  )
end

def instructions
  @instructions ||= input.last.split("\n").map { |line| line.scan(/\d+/).map(&:to_i) }
end

def follow_instruction(stacks, count, source, destination)
  count.times do
    stacks[destination].unshift(stacks[source].shift)
  end
end

def follow_instruction(stacks, count, source, destination)
  stacks[destination].unshift(*stacks[source].shift(count))
end

def rearrange_crates
  initial_stacks.tap do |stacks|
    instructions.each { |instruction| follow_instruction(stacks, *instruction) }
  end
end

def heads_of_stacks(stacks)
  stacks.values.map(&:first).join
end

if __FILE__ == $0
  puts heads_of_stacks(rearrange_crates)
end