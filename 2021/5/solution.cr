class Point
  getter x, y, vents

  def initialize(@x : Int32, @y : Int32)
    @vents = 0
  end

  def add_vent
    @vents += 1
  end

  def to_s
    "(#{x}, #{y})"
  end
end

struct Line
  getter start, finish

  def initialize(@start : Point, @finish : Point)
  end

  def is_diagonal
    !is_horizontal && !is_vertical
  end

  def is_horizontal
    @start.x == @finish.x
  end

  def is_vertical
    @start.y == @finish.y
  end

  def to_s
    "#{@start.to_s} -> #{@finish.to_s}"
  end
end

class VentMap
  getter overlapping_vents

  def initialize(lines : Array(Line), include_diagonals : Bool = false)
    @map = {} of Int32 => Hash(Int32, Point)
    @overlapping_vents = 0

    lines.each do |line| 
      next if !include_diagonals && line.is_diagonal
      draw line
    end
  end

  private def draw(line : Line)
    x = line.start.x
    y = line.start.y

    finished = false
    until finished
      if !@map[x]?
        @map[x] = {} of Int32 => Point
      end

      if !@map[x][y]?
        @map[x][y] = Point.new x, y
      end
      
      @map[x][y].add_vent

      if @map[x][y].vents == 2
        @overlapping_vents += 1
      end

      if x == line.finish.x && y == line.finish.y
        finished = true
      end

      if x != line.finish.x
        x += (x > line.finish.x ? -1 : 1)
      end

      if y != line.finish.y
        y += (y > line.finish.y ? -1 : 1)
      end
    end
  end
end

lines = File.read_lines("./input.txt").map do |line|
  points = line.split(" -> ").map do |coord|
    vals = coord.split(",").map { |v| v.to_i }
    Point.new vals[0], vals[1]
  end
  Line.new points[0], points[1]
end

# Part 1
vent_map = VentMap.new lines
puts vent_map.overlapping_vents

# Part 2
vent_map = VentMap.new lines, include_diagonals: true
puts vent_map.overlapping_vents
