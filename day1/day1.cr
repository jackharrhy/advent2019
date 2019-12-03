total = 0
STDIN.each_line do |line|
  total += ((line.to_u64 / 3).floor) - 2
end
puts total
