require "colorize"

class Height
  getter value : Int32

  def initialize(value : String)
    @value = value.to_i
  end
end

Heightmap = File.read_lines("./input.txt").map do |line|
  line.split("").map { |value| Height.new value }
end

X_max = Heightmap.size - 1
Y_max = Heightmap[0].size - 1

Low_points = [] of Tuple(Tuple(Int32, Int32), Int32)

Heightmap.each_with_index do |row, i|
  row.each_with_index do |_, j|
    height = Heightmap[i][j]
    is_y_min = i == 0
    is_y_max = i == Y_max
    is_x_min = j == 0
    is_x_max = j == X_max

    up = !is_y_min ? Heightmap[i - 1][j].value : 10
    down = !is_y_max ? Heightmap[i + 1][j].value : 10

    left =  !is_x_min ? Heightmap[i][j - 1].value : 10
    right = !is_x_max ? Heightmap[i][j + 1].value : 10

    val = height.value
    if val < up && val < down && val < left && val < right
      Low_points.push({ {i, j}, val })
    end
  end
end

sum = Low_points.reduce(0) { |acc, l| acc + l[1] + 1 }
puts sum

Basins = {} of String => Int32
SeenPoints = Set.new([] of String)

def traverse(point : Tuple(Int32, Int32)): Int32
  i = point[0]
  j = point[1]
  pointStr = "#{i},#{j}"

  return 0 if SeenPoints.includes? pointStr
  return 0 if Heightmap[i][j].value > 8

  SeenPoints.add pointStr

  is_y_min = i == 0
  above = is_y_min ? 0 : traverse({i - 1, j})

  is_y_max = i == Y_max
  below = is_y_max ? 0 : traverse({i + 1, j})

  is_x_min = j == 0
  left = is_x_min ? 0 : traverse({i, j - 1})

  is_x_max = j == X_max
  right = is_x_max ? 0 : traverse({i, j + 1})

  above + below + left + right + 1
end

basins = Low_points.map { |l| traverse(l[0]) }.sort
puts basins[-1] * basins[-2] * basins[-3]
