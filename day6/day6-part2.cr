class Planet
  property name : String = ""
  property child : Array(Planet) = [] of Planet
  property parent : Array(Planet) = [] of Planet
end

galaxy = Hash(String, Planet).new

STDIN.each_line do |line|
  # keep track of the two planets in this context
  planets = [] of Planet
  # input contains planet names
  planet_names = line.split(')')

  planet_names.each do |planet_name|
    if !galaxy.has_key? planet_name
      # planet not seen yet, add create it and add to galaxy
      p = Planet.new
      p.name = planet_name
      galaxy[planet_name] = p
      planets << p
    else
      # planet seen before, add to planets
      planets << galaxy[planet_name]
    end
  end

  # set the orbiting planets of the first entry in the input
  parent, child = planet_names
  galaxy[parent].child << galaxy[child]
  galaxy[child].parent << galaxy[parent]
end

you = galaxy["YOU"]
san = galaxy["SAN"]

puts you
puts san

exit 0

total_parents = 0

galaxy.each do |name, planet|
  parents = 0
  cur_planet = planet

  while cur_planet.is_a? Planet && cur_planet.parent.size != 0
    parents += 1
    cur_planet = cur_planet.parent[0]
  end

  total_parents += parents
end

puts "total: #{total_parents}"
