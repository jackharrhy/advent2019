def calculate_fuel(mass)
  (mass / 3).floor - 2
end

def calculate_fuel_with_fuel_weight(mass)
  current_weight = calculate_fuel(mass)
  if current_weight <= 0
    return 0
  else
    return current_weight + calculate_fuel_with_fuel_weight(current_weight)
  end
end

total = 0
STDIN.each_line do |line|
  total += calculate_fuel_with_fuel_weight(line.to_f)
end
puts total.to_u64
