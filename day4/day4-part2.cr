#range = 347312..805915
range = 111122..111122

found = 0

range.each do |num|
  fail = false
  last = -1
  doubles = Hash(Int32, Int32).new

  num.to_s.chars.each do |n_as_char|
    next if fail

    n = n_as_char.to_i

    if last == n
      if !doubles.has_key? n
        doubles[n] = 2
      else
        doubles[n] += 1 
      end
    end

    fail = true if last > n
    last = n
  end

  # iterate through found doubles

  pp doubles

  exit 0

  found += 1 if !fail 
end

puts found
