#    0:      1:      2:      3:      4:
#   aaaa    ....    aaaa    aaaa    ....
#  b    c  .    c  .    c  .    c  b    c
#  b    c  .    c  .    c  .    c  b    c
#   ....    ....    dddd    dddd    dddd
#  e    f  .    f  e    .  .    f  .    f
#  e    f  .    f  e    .  .    f  .    f
#   gggg    ....    gggg    gggg    ....
#  
#    5:      6:      7:      8:      9:
#   aaaa    aaaa    aaaa    aaaa    aaaa
#  b    .  b    .  .    c  b    c  b    c
#  b    .  b    .  .    c  b    c  b    c
#   dddd    dddd    ....    dddd    dddd
#  .    f  e    f  .    f  e    f  .    f
#  .    f  e    f  .    f  e    f  .    f
#   gggg    gggg    ....    gggg    gggg


# Digits 1, 4, 7, and 8 have a unique number of segments
# (2, 4, 3, and 7 respectively)

# Using the mapping defined above:
# 0 to 9:
# 0:abcefg 1:cf 2:acdeg 3:acdfg 4:bcdf 5:abdfg 6:abdefg 7:acf 8:abcdefg 9:abcdfg
# 6        2    5       5       4      5       6        3     7         6

# Segment usages:
# a:8 b:6 c:8 d:7 e:4 f:9 g:7

class SignalPattern
  getter digits : Array(String)

  def initialize(input : String)
    @digits = input.split(" ").map { |d| d.split("").sort.join("") }
  end
end

class OutputValue
  getter digits : Array(String)

  def initialize(input : String)
    @digits = input.split(" ").map { |d| d.split("").sort.join("") }
  end
end

class NoteEntry
  getter signal, output, output_val

  @output_val : Int32

  def print
    puts "#{@signal.digits.join(" ")} | #{@output.digits.join(" ")}"
  end

  def initialize(input : String)
    arr = input.split(" | ")

    @signal = SignalPattern.new arr[0]
    @output = OutputValue.new arr[1]

    segment_counts = @signal.digits.reduce({} of String => Int32) do |map, digit|
      digit.split("").each do |segment|
        map[segment] = 0 if !map[segment]?
        map[segment] += 1
      end
      map
    end

    # b, e, and f are easy since they are each used a different number of times
    b = (segment_counts.find { |seg, count| count == 6 }.try &.[0]).not_nil!
    e = (segment_counts.find { |seg, count| count == 4 }.try &.[0]).not_nil!
    f = (segment_counts.find { |seg, count| count == 9 }.try &.[0]).not_nil!

    # a and c are both used 8 times
    digit_1 = @signal.digits.find { |digit| digit.size == 2 }.not_nil!
    digit_7 = @signal.digits.find { |digit| digit.size == 3 }.not_nil!

    a = digit_7.split("").find { |seg| !digit_1.includes? seg }.not_nil!
    c = (segment_counts.find { |seg, count| count == 8 && seg != a }.try &.[0]).not_nil!

    # d and g are both used 7 times
    digit_4 = @signal.digits.find { |digit| digit.size == 4 }.not_nil!

    d = (digit_4.split("").find { |seg| seg != b && seg != c && seg != f }).not_nil!
    g = (segment_counts.find { |seg, count| count == 7 && seg != d}.try &.[0]).not_nil!

    digit_0 = @signal.digits.find do |digit|
      digit.size == 6 &&
      digit.includes?(a) &&
      digit.includes?(b) &&
      digit.includes?(c) &&
      digit.includes?(e) &&
      digit.includes?(f) &&
      digit.includes?(g)
    end.not_nil!

    digit_2 = @signal.digits.find do |digit|
      digit.size == 5 &&
      digit.includes?(a) &&
      digit.includes?(c) &&
      digit.includes?(d) &&
      digit.includes?(e) &&
      digit.includes?(g)
    end.not_nil!

    digit_3 = @signal.digits.find do |digit|
      digit.size == 5 &&
      digit.includes?(a) &&
      digit.includes?(c) &&
      digit.includes?(d) &&
      digit.includes?(f) &&
      digit.includes?(g)
    end.not_nil!

    digit_5 = @signal.digits.find do |digit|
      digit.size == 5 && digit != digit_2 && digit != digit_3
    end.not_nil!

    digit_6 = @signal.digits.find do |digit|
      digit.size == 6 &&
      digit.includes?(a) &&
      digit.includes?(b) &&
      digit.includes?(d) &&
      digit.includes?(e) &&
      digit.includes?(f) &&
      digit.includes?(g)
    end.not_nil!

    digit_8 = @signal.digits.find { |digit| digit.size == 7 }.not_nil!

    digit_9 = @signal.digits.find do |digit|
      digit.size == 6 && digit != digit_6 && digit != digit_0
    end.not_nil!

    digits_map = {} of String => Int32
    digits_map[digit_0] = 0
    digits_map[digit_1] = 1
    digits_map[digit_2] = 2
    digits_map[digit_3] = 3
    digits_map[digit_4] = 4
    digits_map[digit_5] = 5
    digits_map[digit_6] = 6
    digits_map[digit_7] = 7
    digits_map[digit_8] = 8
    digits_map[digit_9] = 9

    @output_val = @output.digits.each_with_index.reduce(0) do |acc, (digit, idx)|
      acc + digits_map[digit].try &.*(10 ** (3 - idx))
    end
  end
end

entries = File.read_lines("./input.txt").map do |line|
  NoteEntry.new line
end

count = entries.reduce(0) do |sum, entry|
  sum + entry.output.digits.reduce(0) do |entry_sum, digit|
    entry_sum + (
      digit.size == 2 ||
      digit.size == 3 ||
      digit.size == 4 ||
      digit.size == 7 ? 1 : 0)
  end
end

puts count

total = entries.reduce(0) do |sum, entry|
  sum + entry.output_val
end

puts total
