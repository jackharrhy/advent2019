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

parents_of_you = Hash(String, Tuple(Planet, Int32)).new
cur_planet = you
parent_num = -1

while cur_planet.is_a? Planet && cur_planet.parent.size != 0
  parents_of_you[cur_planet.name] = {cur_planet, parent_num}
  cur_planet = cur_planet.parent[0]
  parent_num += 1
end

cur_planet = san
parent_num = -1

while cur_planet.is_a? Planet && cur_planet.parent.size != 0
  parent_num += 1
  cur_planet = cur_planet.parent[0]
  if parents_of_you.has_key? cur_planet.name
    you_num = parents_of_you[cur_planet.name][1]
    puts parent_num + you_num
    break
  end
end
