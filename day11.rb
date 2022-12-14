require 'fiber'
class Monkey
  attr_accessor :items, :divisible, :if_true, :if_false, :inspected_items

  def initialize(items, divisible, operation, if_true, if_false, div)
    @items = items
    @divisible = divisible.to_i
    @operation = ->(_old) { eval(operation) }
    @if_true = if_true.to_i
    @if_false = if_false.to_i
    @div = div
    @inspected_items = 0
  end

  def inspect_item(monkeys, lcm)
    @inspected_items += 1
    item = (@operation.call(items.pop) / @div) % lcm
    if (item % divisible).zero?
      monkeys[if_true].items.push(item)
    else
      monkeys[if_false].items.push(item)
    end
  end
end

def input
  @input ||= File.read('input/11.txt').split("\n")
end

def next_line
  @fiber ||= Fiber.new do
    input.each do |line|
      Fiber.yield line
    end
  end
end

def initialize_monkeys(div)
  monkeys = []

  while next_line.alive?
    next_line.resume # number
    items = next_line.resume.scan(/\d+/).map(&:to_i)
    (_, operation) = next_line.resume.split(': ') # TODO: improve this with regex
    (_, divisible) = next_line.resume.split('by ') # TODO: improve this with regex
    (_, if_true) = next_line.resume.split('monkey ') # TODO: improve this with regex
    (_, if_false) = next_line.resume.split('monkey ') # TODO: improve this with regex
    monkeys << Monkey.new(items, divisible, operation, if_true, if_false, div)
    next_line.resume # empty line
  end

  monkeys
end

def monkeys(div = nil)
  @monkeys ||= initialize_monkeys(div)
end

# https://docs.ruby-lang.org/en/2.1.0/Integer.html#method-i-lcm
def lcm
  @lcm ||= monkeys.map { |monkey| monkey.divisible }.reduce(:lcm)
end

def play_round(div)
  monkeys(div).each do |monkey|
    monkey.items.count.times do
      monkey.inspect_item(monkeys, lcm)
    end
  end
end

def play_game(rounds, div)
  reset_game
  rounds.times { play_round(div) }
end

def reset_game
  @monkeys = nil
  @fiber = nil
end

def monkey_business
  monkeys.max_by(2) { |monkey| monkey.inspected_items }.collect(&:inspected_items).reduce(:*)
end

if __FILE__ == $0
  play_game(20, 3)
  puts monkey_business
  play_game(10_000, 1)
  puts monkey_business
end
