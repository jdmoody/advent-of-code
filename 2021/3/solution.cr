diagnostic_report = File.read_lines("./input.txt").map do |num|
  num.split("").map { |digit| digit.to_i }
end

alias DiagnosticReport = Array(Array(Int32))

def calculate_gamma(nums : DiagnosticReport)
  nums.reduce do |sum, num|
    if sum
      next sum.zip(num).map { |sum_digit, num_digit| sum_digit + num_digit }
    end

    next num
  end
    .map do |ones|
      zeroes = nums.size - ones
      ones >= zeroes ? 1 : 0
    end
end

def calculate_epsilon(nums : DiagnosticReport)
  calculate_gamma(nums).map { |num| num === 1 ? 0 : 1 }
end

# Part 1
gamma = calculate_gamma diagnostic_report
epsilon = calculate_epsilon diagnostic_report
puts gamma.join.to_i(2) * epsilon.join.to_i(2)

# Part 2
def calculate_oxygen(nums : DiagnosticReport)
  possible_values = nums
  bit_position = 0

  while possible_values.size > 1
    gamma = calculate_gamma possible_values
    possible_values = possible_values.select do |num|
      num[bit_position] == gamma[bit_position] 
    end

    bit_position += 1
  end

  return possible_values[0].join.to_i(2)
end


def calculate_co2(nums : DiagnosticReport)
  possible_values = nums
  bit_position = 0

  while possible_values.size > 1
    epsilon = calculate_epsilon possible_values
    possible_values = possible_values.select do |num|
      num[bit_position] == epsilon[bit_position]
    end

    bit_position += 1
  end

  return possible_values[0].join.to_i(2)
end

oxygen = calculate_oxygen diagnostic_report
co2 = calculate_co2 diagnostic_report
puts oxygen * co2
