require "colorize"

input = File.read("./input.txt").split("\n\n")

draw_numbers = input.shift().split(",").map { |num| num.to_i }

struct Position
  getter board_id, row, col

  def initialize(@board_id : Int32, @row : Int32, @col : Int32)
  end
end

class BingoNumber
  getter positions, val
  property called

  def initialize(@val : Int32)
    @called = false
    @positions = [] of Position
  end

  def add_position(position : Position)
    @positions.push position
  end
end

class Board
  @score : Int32?

  @row_hits : Array(Int32)
  @col_hits : Array(Int32)
  
  getter score

  def initialize(@numbers : Array(Array(BingoNumber)))
    @row_hits = @numbers.map { |c| 0 }
    @col_hits = @numbers[0].map { |n| 0 }
    @primary_diagonal_hits = 0
    @secondary_diagonal_hits = 0
  end

  def print
    @numbers.each do |row|
      puts (row.map do |n|
        val = n.val < 10 ? " #{n.val}" : "#{n.val}"
        n.called ? val.colorize(:green) : val
      end.join(" "))
    end
  end

  def hit(value : Int32, position : Position)
    @row_hits[position.row] += 1
    @col_hits[position.col] += 1

    if position.row == position.col
      @primary_diagonal_hits += 1
    elsif position.row + position.col == 4
      @secondary_diagonal_hits += 1
    end

    if @row_hits[position.row] == 5 ||
       @col_hits[position.col] == 5 ||
       @primary_diagonal_hits == 5 ||
       @secondary_diagonal_hits == 5

      set_score(value)
    end

  end

  private def set_score(winning_number)
    @score = winning_number * @numbers.reduce(0) do |row_sum, row|
      row_sum + row.reduce(0) do |sum, num|
        if num.called
          next sum
        end

        sum + num.val
      end
    end
  end
end

# Part 1
numbers_map = {} of Int32 => BingoNumber

boards = input.map_with_index do |board, i|
  numbers = board.split("\n").map_with_index do |row, j|
    row.split().map { |num| num.to_i }.map_with_index do |num, k|
      position = Position.new(board_id: i, row: j, col: k) 

      if !numbers_map[num]?
        numbers_map[num] = BingoNumber.new(num)
      end

      numbers_map[num].add_position(position)

      numbers_map[num]
    end
  end

  Board.new(numbers)
end

first_winner_score : Int32? = nil
draw_numbers.dup.each do |val|
  if first_winner_score
    break
  end

  num = numbers_map[val] 

  num.called = true
  num.positions.each do |position|
    board = boards[position.board_id]
    board.hit num.val, position

    score = board.score
    if score
      first_winner_score = score
      break
    end
  end
end

puts "First winner score: #{first_winner_score}"

# Part 2
numbers_map = {} of Int32 => BingoNumber

boards = input.map_with_index do |board, i|
  numbers = board.split("\n").map_with_index do |row, j|
    row.split().map { |num| num.to_i }.map_with_index do |num, k|
      position = Position.new(board_id: i, row: j, col: k) 

      if !numbers_map[num]?
        numbers_map[num] = BingoNumber.new(num)
      end

      numbers_map[num].add_position(position)

      numbers_map[num]
    end
  end

  Board.new(numbers)
end

last_winner_score : Int32? = nil
draw_numbers.each do |val|
  num = numbers_map[val] 
  num.called = true
  num.positions.each do |position|
    board = boards[position.board_id]
    if board.score
      next
    end

    board.hit num.val, position

    if board.score
      last_winner_score = board.score
    end
  end
end

puts "Last winner score: #{last_winner_score}"
