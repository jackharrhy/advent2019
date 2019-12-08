m = [] of Int32

STDIN.each_line do |line|
  line.split(",").each do |i|
    m.push i.to_i32
  end
end

args = [1]

def run(m, args)
  c = 0

  until m[c] == 99
    # parse out the opcode, the right-most two digits
    instructs = m[0].to_s
    opcode = instructs[instructs.size - 2, instructs.size].to_i

    # parse the remaining mode instructions, including the omitted param
    modes = instructs.chars.map { |m| m.to_i }
    modes.pop 2
    modes.unshift 0 if modes.size == 2

    # make a note of both the actual positions and values of the items
    positions = [] of Int32
    params = [] of Int32

    (1..3).each do |x|
      param = m[c + x]?.is_a?(Int32) ? m[c + x] : 0
      positions << param
      # resolve real location if not in immediate mode
      param = m[param] if modes[x - 1] == 0
      params << param
    end

    p1, p2, p3 = positions
    pr1, pr2, pr3 = params

    case opcode
    when 1
      m[p3] = pr1 + pr2
      c += 4
    when 2
      m[p3] = pr1 * pr2
      c += 4
    when 3
      int = args.shift
      m[p1] = int
      c += 2
    when 4
      puts pr1
      c += 2
    end
  end

  pp m
end

run(m, args)
