m = [] of Int32

STDIN.each_line do |line|
  line.split(",").each do |i|
    m.push i.to_i32
  end
end

c = 0

until m[c] == 99
  puts "machine: #{m}"
  puts "current: #{c} - #{m[c]}"

  p1 = m[c+1]
  p2 = m[c+2]
  p3 = m[c+3]

  case m[c]
  when 1
    m[p3] = m[p1] + m[p2]
  when 2
    m[p3] = m[p1] * m[p2]
  end
  c += 4
end

puts "\nCOMPLETE"
puts "machine: #{m}"
puts "current: #{c} - #{m[c]}"
puts "value as machine[0] = #{m[0]}"
