require "big"

beginning_fish = File.read("./input.txt").split(",").reduce({} of Int32 => BigInt) do |fish_by_age, f|
  age = f.to_i
  if !fish_by_age[age]?
    fish_by_age[age] = BigInt.new 1
  else
    fish_by_age[age] += 1
  end
  
  fish_by_age
end

def fish_at_day(final_day : Int32, fish : Hash(Int32, BigInt))
  day = 0
  new_fish = {} of Int32 => BigInt
  until day == final_day
    age = 0
    new_fish = {} of Int32 => BigInt

    until age == 9
      fish[age] = BigInt.new 0 if !fish[age]?
      new_fish[age] = BigInt.new 0 if !new_fish[age]?
        
      if age == 0
        new_fish[6] = fish[age]
        new_fish[8] = fish[age]
      else
        new_fish[age - 1] += fish[age]
      end

      age += 1
    end

    fish = new_fish
    day += 1
  end

  total = 0
  age = 0
  until age == 9
    total += new_fish[age]
    age += 1
  end

  total
end

puts fish_at_day(80, beginning_fish)
puts fish_at_day(256, beginning_fish)


