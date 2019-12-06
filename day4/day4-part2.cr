range = 347312..805915

found = 0

range.each do |num|
  fail = false
  double_exists = false
  last = -1

  groups = Hash(Int32, Int32).new

  num.to_s.chars.each do |n_as_char|
    next if fail

    n = n_as_char.to_i

    if last == n
      if !groups.has_key? n
        groups[n] = 2
      else
        groups[n] += 1
      end
    end

    fail = true if last > n
    last = n
  end

  if !fail && groups.size > 0
    fail = true
    groups.each do |group|
      fail = false if group[1] == 2
    end
    found += 1 if !fail
  end
end

puts found
