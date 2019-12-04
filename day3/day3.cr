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
  p = [0, 0]

  line.split(",").each do |str|
    direction = str.char_at 0
    range = 1..str[1, str.size].to_i
    vec = generate_vec(direction)

    range.each do |move|
      board[p[0]] = Hash(Int32, Int32).new if !board.has_key? p[0]
      board[p[0]][p[1]] = line_num if !board[p[0]].has_key? p[1]

      if board[p[0]][p[1]] != line_num
        hits << p.clone
      end

      board[p[0]][p[1]] = line_num

      p[0] += vec[0]
      p[1] += vec[1]
    end
  end
end

hits.shift

least = -1
hits.each do |hit|
  p = [0, 0]
  q = [hit[0].abs, hit[1].abs]
  taxi = ((p[0] - q[0]) + (p[1] - q[1])).abs

  least = taxi if taxi < least || least == -1
end
puts least
