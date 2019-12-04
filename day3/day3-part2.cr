def generate_vec(direction)
  case direction
  when 'L'
    return [-1, 0]
  when 'U'
    return [0, 1]
  when 'R'
    return [1, 0]
  when 'D'
    return [0, -1]
  end
  raise "invalid direction: #{direction}"
end

board = Hash(Int32, Hash(Int32, Int32)).new

line_num = -1

hits = Array(Array(Int32)).new

STDIN.each_line do |line|
  line_num += 1
  step = 0
  p = [0, 0]

  line.split(",").each do |str|
    direction = str.char_at 0
    range = 1..str[1, str.size].to_i
    vec = generate_vec(direction)

    range.each do |move|
      board[p[0]] = Hash(Int32, Int32).new if !board.has_key? p[0]

      if !board[p[0]].has_key? p[1]
        board[p[0]][p[1]] = step
      else
        hits << [step, board[p[0]][p[1]]]
      end

      board[p[0]][p[1]] = step

      p[0] += vec[0]
      p[1] += vec[1]
      step += 1
    end
  end
end

if hits.size == 0
  puts "invalid hits"
  exit 1
end

hits.shift

least_cost = -1
hits.each do |hit|
  next if hit[0] == 0 && hit[1] == 0

  cost = hit[0] + hit[1]
  if cost < least_cost || least_cost == -1
    puts hit
    least_cost = cost
  end
end

puts least_cost
