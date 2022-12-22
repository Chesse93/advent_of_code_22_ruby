require 'benchmark'

FIXNUM_MAX = 1 << 65

def input
  @input ||= File.read('input/21.txt').split("\n")
end

def parse_input(humn = false)
  yelling_monkeys = {}
  calculating_monkeys = {}

  input.each do |line|
    case line
    when /(\w+): (\d+)/
      yelling_monkeys[Regexp.last_match(1)] = Regexp.last_match(2).to_i
    when %r{(\w+): (\w+) ([+\-*/]) (\w+)}
      operator = Regexp.last_match(1) == 'root' && humn == true ? '<=>' : Regexp.last_match(3)
      calculating_monkeys[Regexp.last_match(1)] =
[Regexp.last_match(2), operator, Regexp.last_match(4)]
    end
  end

  [yelling_monkeys, calculating_monkeys]
end

def calculating_root(calculating_monkeys, yelling_monkeys)
  loop do
    calculating_monkeys.each do |k, v|
      v.each_with_index do |e, i|
        calculating_monkeys[k][i] = yelling_monkeys[e] if yelling_monkeys[e]
      end
    end

    calculating_monkeys.clone.each do |k, v|
      next unless v in [Integer => number1, String => operator, Integer => number2]

      yelling_monkeys[k] = number1.method(operator).call(number2)
      return yelling_monkeys[k] if k == 'root'

      calculating_monkeys.delete(k)
    end
  end
end

def day_21_1
  yelling_monkeys, calculating_monkeys = parse_input

  calculating_root(calculating_monkeys, yelling_monkeys)
end

def day_21_2
  min = 0
  max = FIXNUM_MAX - 1
  first_round = true
  direction = 1

  while min < max
    yelling_monkeys, calculating_monkeys = parse_input(true)

    yelling_monkeys['humn'] = (min + max).round / 2

    root = calculating_root(calculating_monkeys, yelling_monkeys)

    direction = -1 if first_round && root == 1
    first_round = false

    if root.zero?
      return yelling_monkeys['humn']
    elsif root == direction
      min = yelling_monkeys['humn'] + 1
    else
      max = yelling_monkeys['humn'] - 1
    end
  end
end

if __FILE__ == $0
  Benchmark.bm(10) do |x|
    x.report('Day 21_1:') { puts day_21_1 }
    x.report('Day 21_2:') { puts day_21_2 }
  end
end
