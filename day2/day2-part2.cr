m = [] of Int32

STDIN.each_line do |line|
  line.split(",").each do |i|
    m.push i.to_i32
  end
end

def run(m)
  c = 0

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

  m[0]
end

possible_nouns = 0..99
possible_verbs = 0..99

possible_nouns.each do |noun|
  possible_verbs.each do |verb|
    mcopy = m.clone
    mcopy[1] = noun
    mcopy[2] = verb
    result = run(mcopy)
    if result == 19690720
      puts 100 * noun + verb
      exit 0
    end
  end
end
