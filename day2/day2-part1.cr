m = [] of Int32
c = 0

STDIN.each_line do |line|
  line.split(",").each do |i|
    m.push i.to_i32
  end
end

until m[c] == 99
  p1 = m[c + 1]
  p2 = m[c + 2]
  p3 = m[c + 3]

  case m[c]
  when 1
    m[p3] = m[p1] + m[p2]
  when 2
    m[p3] = m[p1] * m[p2]
  end
  c += 4
end

puts m[0]
