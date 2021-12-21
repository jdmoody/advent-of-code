Octopi = File.read_lines("./input.txt").map { |l| l.split("").map { |o| o.to_i } }

YMax = Octopi.size
XMax = Octopi[0].size

flashes = 0

def flash(i : Int32, j : Int32, flashes : Int32)
  Octopi[i][j] = -1
  flashes += 1

  [-1, 0, 1].each do |x|
    [-1, 0, 1].each do |y|
      new_i = i + y
      new_j = j + x
      if new_i > -1 && new_i < YMax && new_j > -1 && new_j < XMax
        flashes = increment(new_i, new_j, flashes)
      end
    end
  end

  flashes
end

def increment(i : Int32, j : Int32, flashes : Int32)
  return flashes if Octopi[i][j] == -1

  Octopi[i][j] += 1

  if Octopi[i][j] > 9
    return flash(i, j, flashes)
  end

  return flashes
end

100.times do
  Octopi.each_with_index do |row, i|
    row.each_with_index do |_, j|
      flashes = increment(i, j, flashes)
    end
  end

  Octopi.each_with_index do |row, i|
    row.each_with_index do |_, j|
      Octopi[i][j] = 0 if Octopi[i][j] == -1
    end
  end
end

puts flashes

step = 100
synchronized = false
while !synchronized
  step += 1

  Octopi.each_with_index do |row, i|
    row.each_with_index do |_, j|
      flashes = increment(i, j, flashes)
    end
  end

  Octopi.each_with_index do |row, i|
    row.each_with_index do |_, j|
      Octopi[i][j] = 0 if Octopi[i][j] == -1
    end
  end

  synchronized = Octopi.all? do |row|
    row.all? { |val| val == 0 }
  end
end

puts step
