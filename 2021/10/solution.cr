require "big"

lines = File.read_lines("./input.txt")

openers = Set{"(", "[", "{", "<"}
closers = {
  ")" => "(",
  "]" => "[",
  "}" => "{",
  ">" => "<"
}
closerScores = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137
}

evaluations = lines.map do |line|
  score = line.split("").reduce([] of String) do |chunks, char|
    if openers.includes? char
      chunks.push char
      next chunks
    end

    lastOpener = chunks.last?
    if closers[char] != lastOpener
      break closerScores[char]
    end

    chunks.pop
    chunks
  end
end

scores = evaluations.map { |e| e.is_a?(Int32) ? e : 0 }
total = scores.reduce(0) { |total, score| total + score }
puts total

openerScores = {
  "(" => 1,
  "[" => 2,
  "{" => 3,
  "<" => 4
}

scores = evaluations.reject(Int32)
  .map do |remaining|
    remaining.reverse.reduce(BigInt.new(0)) do |score, char|
      5 * score + openerScores[char]
    end
  end
  .sort

puts scores[(scores.size / 2).to_i]
