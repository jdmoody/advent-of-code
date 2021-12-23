class Cave
  getter id, is_small : Bool, connections

  def initialize(id : String)
    @id = id
    @is_small = !id[0].uppercase?
    @connections = Set(Cave).new
  end

  def connect(cave : Cave)
    @connections.add cave
  end

  def paths_to_end(visited_caves : Set(Cave), allow_double_visit : Bool = false, double_visited_cave : Cave? = nil): Int32
    return 1 if @id == "end"

    v = Set(Cave).new(visited_caves)
    if visited_caves.includes?(self) && @is_small
      # This path is invalid if we have already visited a small cave twice or this is the start/end cave
      return 0 if !allow_double_visit || !!double_visited_cave || @id == "start" || @id == "end"

      # Otherwise, we get to visit this small cave again
      v.delete(self)
      return self.paths_to_end(v, allow_double_visit, self)
    end

    @connections.reduce(0) do |paths, cave|
      paths + cave.paths_to_end(Set(Cave).new(visited_caves).add(self), allow_double_visit, double_visited_cave)
    end
  end
end

class CaveMap
  property start : Cave?

  def initialize()
    @map = {} of String => Cave

    File.read_lines("./input.txt").each do |path|
      caves = path.split("-")

      cave_0 = @map[caves[0]]?
      if !cave_0
        cave_0 = Cave.new caves[0]
        @map[cave_0.id] = cave_0
      end

      cave_1 = @map[caves[1]]?
      if !cave_1
        cave_1 = Cave.new caves[1]
        @map[cave_1.id] = cave_1
      end

      cave_0.connect cave_1
      cave_1.connect cave_0

      # Set the start if it hasn't been set yet
      if !@start
        @start = cave_0 if cave_0.id == "start"
        @start = cave_1 if cave_1.id == "start"
      end
    end
  end
end

# Construct the full cave_map
cave_map = CaveMap.new

puts cave_map.start.try &.paths_to_end(Set(Cave).new)
puts cave_map.start.try &.paths_to_end(Set(Cave).new, true)
