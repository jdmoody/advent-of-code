# Part 1
final_position = File.read_lines("./input.txt")
  .each
  .map { |command_str| command_str.split(" ") }
  .map { |command_arr| {name: command_arr[0], arg: command_arr[1].to_i } }
  .reduce({horiz: 0, depth: 0}) do |pos, command|

    if command[:name] == "forward"
      next { horiz: pos[:horiz] + command[:arg], depth: pos[:depth] }
    elsif command[:name] == "down"
      next { horiz: pos[:horiz], depth: pos[:depth] + command[:arg] }
    elsif command[:name] == "up"
      next { horiz: pos[:horiz], depth: pos[:depth] - command[:arg] }
    end

    next pos
  end

puts final_position
puts final_position[:horiz] * final_position[:depth]

# Part 2
final_position = File.read_lines("./input.txt")
  .each
  .map { |command_str| command_str.split(" ") }
  .map { |command_arr| {name: command_arr[0], arg: command_arr[1].to_i } }
  .reduce({horiz: 0, depth: 0, aim: 0}) do |pos, command|

    if command[:name] == "forward"
      next { horiz: pos[:horiz] + command[:arg], depth: pos[:depth] + pos[:aim] * command[:arg], aim: pos[:aim]  }

    elsif command[:name] == "down"
      next { horiz: pos[:horiz], depth: pos[:depth], aim: pos[:aim] + command[:arg] }

    elsif command[:name] == "up"
      next { horiz: pos[:horiz], depth: pos[:depth], aim: pos[:aim] - command[:arg] }

    end

    next pos
  end

puts final_position
puts final_position[:horiz] * final_position[:depth]
