range = 347312..805915

found = 0

range.each do |num|
  fail = false
  double_exists = false
  last = -1

  num.to_s.chars.each do |n_as_char|
    next if fail

    n = n_as_char.to_i

    double_exists = true if last == n
    fail = true if last > n
    last = n
  end

  fail = true if !double_exists

  found += 1 if !fail
end

puts found
