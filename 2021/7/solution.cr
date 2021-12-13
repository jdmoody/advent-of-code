positions = File.read("./input.txt").split(",").map { |pos| pos.to_i }
min = positions.min
max = positions.max

# Part 1
min_cost : Int32? = nil
current = min
while current <= max
  total_cost = positions.map do |pos|
    (current - pos).abs
  end
  .reduce do |total, cost|
    total + cost
  end

  current += 1

  min_cost = total_cost if !min_cost || total_cost < min_cost
end

puts min_cost

# Part 2
min_cost = nil
current = min
while current <= max
  total_cost = positions.map do |pos|
    distance = (current - pos).abs
    cost = (distance * (distance + 1) / 2).to_i
    cost
  end
  .reduce do |total, cost|
    total + cost
  end

  current += 1

  min_cost = total_cost if !min_cost || total_cost < min_cost
end

puts min_cost
