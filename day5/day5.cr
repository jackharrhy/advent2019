m = [] of Int32

STDIN.each_line do |line|
  line.split(",").each do |i|
    m.push i.to_i32
  end
end

args = [5]

def run(m, args)
  c = 0

  until m[c] == 99
    p1 = m[c + 1]?.is_a?(Int32) ? m[c + 1] : 0
    p2 = m[c + 2]?.is_a?(Int32) ? m[c + 2] : 0
    p3 = m[c + 3]?.is_a?(Int32) ? m[c + 3] : 0

    case m[c]
    when 1
      m[p3] = m[p1] + m[p2]
      c += 4
    when 2
      m[p3] = m[p1] * m[p2]
      c += 4
    when 3
      int = args.shift
      m[p1] = int
      c += 2
    when 4
      puts m[p1]
      c += 2
    end
  end

  m[0]
end

run(m, args)
