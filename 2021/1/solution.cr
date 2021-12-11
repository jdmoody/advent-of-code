def calculate_depth_increases(depths : Array(String), window_size = 1)
  return depths.each
    .map { |depth| depth.to_i }
    .reduce({prev: nil, window: [] of Int32, increases: 0}) do |state, depth|

      # Update the window
      state[:window].push depth
      if state[:window].size > window_size
        state[:window].shift
      end

      # If have a full window, start doing depth comparisons
      if state[:window].size === window_size
        avg_depth = state[:window].reduce { |acc, d| acc + d }

        # If the depth has increased, increment
        if state[:prev].try &.< avg_depth
          next {prev: avg_depth, window: state[:window], increases: state[:increases] + 1}
        end
        
        # Otherwise, do nothing
        next {prev: avg_depth, window: state[:window], increases: state[:increases]}
      end

      next {prev: nil, window: state[:window], increases: state[:increases]}
    end[:increases]
end

depths = File.read_lines("./input.txt")

# Part 1
puts calculate_depth_increases depths

# Part 2
puts calculate_depth_increases depths, window_size: 3
