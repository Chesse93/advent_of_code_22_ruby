if __FILE__ == $0
    # Example output: [[2..90, 91..96], ...]
    pairs = File.readlines("input/04.txt").map { eval("[#{_1.gsub('-', '..')}]") }

    pp pairs

    # https://apidock.com/ruby/Range/cover%3Fa 
    # Example data: a: 2..90 b: 91..96
    puts(pairs.count { |(a, b)| a.cover?(b) || b.cover?(a) })
    puts(pairs.count { |(a, b)| (a.to_a & b.to_a).any? })
end