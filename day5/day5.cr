m = [] of Int32

STDIN.each_line do |line|
  line.split(",").each do |i|
    m.push i.to_i32
  end
end

def debug
  debug = ENV["DEBUG"] ||= "false"
  debug === "true"
end

args = [1]

def run(m, args)
  d = debug
  c = 0

  opcode_map = {
    1 => 4,
    2 => 4,
    3 => 2,
    4 => 2,
  }

  until m[c] == 99
    puts "\nc: #{c} - #{m[c, 6]}..." if d

    # parse out the opcode, the right-most two digits
    instructs = m[c].to_s

    opcode = instructs[instructs.size - 2, instructs.size].to_i
    raise "opcode more than 4!" if opcode > 4

    opcode_jump = opcode_map[opcode]

    # parse the remaining mode instructions, including the potential omitted param
    modes = instructs.chars.map { |m| m.to_i }
    modes.pop 2
    modes.reverse!

    # make a note of both the actual positions and values of the items
    positions = [] of Int32
    params = [] of Int32

    (1..3).each do |x|
      param = m[c + x]?.is_a?(Int32) ? m[c + x] : 0
      positions << param

      # still handle one-int opcodes, and also
      # resolve real location if not in immediate mode
      mode = modes[x - 1]?
      if modes.size === 0 || mode == 0 || mode == nil
        param = m[param]?.is_a?(Int32) ? m[param] : 0
      end

      params << param
    end

    puts "instructs: #{instructs}, opcode: #{opcode}" if d
    puts "modes: #{modes}, positions: #{positions}, params: #{params}" if d

    case opcode
    when 1
      m[positions[2]] = params[0] + params[1]
    when 2
      m[positions[2]] = params[0] * params[1]
    when 3
      int = args.shift
      m[positions[0]] = int
    when 4
      puts params[0]
    end

    c += opcode_jump
  end
end

run(m, args)
