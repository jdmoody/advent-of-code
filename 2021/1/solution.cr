depths = File.read_lines("./input.txt")
# Part 1
depth_state = depths.each
  .map { |depth| depth.to_i }
  .reduce({prev: nil, increases: 0}) do |state, depth|
    if state[:prev].try &.< depth
      next {prev: depth, increases: state[:increases] + 1}
    end

    next {prev: depth, increases: state[:increases]}
  end

puts depth_state[:increases]

# Part 2
depth_state = depths.each
  .map { |depth| depth.to_i }
  .reduce({prev: nil, window: [] of Int32, increases: 0}) do |state, depth|
    # Update the window
    state[:window].push depth
    if state[:window].size > 3
      state[:window].shift
    end
		
		# If the new window had a depth increase, update the state
		if state[:window].size === 3
      avg_depth = state[:window].reduce { |acc, d| acc + d }
      if state[:prev].try &.< avg_depth
        next {prev: avg_depth, window: state[:window], increases: state[:increases] + 1}
      end
        next {prev: avg_depth, window: state[:window], increases: state[:increases]}
		end

    next {prev: nil, window: state[:window], increases: state[:increases]}
  end

puts depth_state[:increases]
