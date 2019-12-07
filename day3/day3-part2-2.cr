def generate_vec(direction, length)
  case direction
  when 'L'
    return [-1 * length, 0]
  when 'U'
    return [0, length]
  when 'R'
    return [length, 0]
  when 'D'
    return [0, -1 * length]
  end
  raise "invalid direction: #{direction}"
end

# multi-dimensional array, keep track of what line has been where
board = Hash(Int32, Hash(Int32, Int32)).new

hits = Array(Array(Int32)).new

STDIN.each_line do |line|
  # initialize at 0,0 axis
  steps = 0
  point = [0, 0]

  line.split(",").each do |str|
    # parse line, grab vector to move point by
    direction = str.char_at 0
    length = str[1, str.size].to_i
    vec = generate_vec(direction, length)

    # step by the value in vec that isn't 0
    i = 0
    i = 1 if vec[1] != 0

    steps += vec[i].abs

    range = (point[i])..(point[i] + vec[i])

    range.each do |inter|
      dx, dy = point[0], point[1]
      dx += inter if i == 0
      dy += inter if i == 1

      board[dx] = Hash(Int32, Int32).new if !board.has_key? dx

      if !board[dx].has_key? dy
        board[dx][dy] = steps - inter * -1
      else
        puts "HIT"
      end
    end

    point[i] += vec[i]
  end
end

pp board
pp hits

least_cost = 0
puts least_cost
puts "too low!" if least_cost <= 4300
