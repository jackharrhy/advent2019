class IntM
  @@opcode_map = {
    1 => 4,
    2 => 4,
    3 => 2,
    4 => 2,
    5 => 3,
    6 => 3,
    7 => 4,
    8 => 4,
  }

  @m : Array(Int32)
  @debug : Bool

  def initialize(@machine : Array(Int32))
    @m = [] of Int32
    @debug = (ENV["DEBUG"] ||= "false") == "true"
    @c = 0
    @output = [] of Int32
  end

  # parse the remaining mode instructions, including the potential omitted params
  def parse_modes(instructs)
    modes = instructs.chars.map { |instru| instru.to_i }
    modes.pop 2
    modes.reverse
  end

  # make a note of both the relative positions and actual resolved values
  def position_and_params(modes)
    positions = [] of Int32
    params = [] of Int32

    (1..3).each do |x|
      param = @m[@c + x]?.is_a?(Int32) ? @m[@c + x] : 0
      positions << param

      # still handle small param. opcodes, and also
      # resolve real location if not in immediate mode
      mode = modes[x - 1]?
      if modes.size === 0 || mode == 0 || mode == nil
        param = @m[param]?.is_a?(Int32) ? @m[param] : 0
      end

      params << param
    end

    {positions, params}
  end

  def cycle(args)
    # parse out the opcode, the right-most two digits
    instructs = @m[@c].to_s
    opcode = instructs[instructs.size - 2, instructs.size].to_i
    raise "opcode more than 8!" if opcode > 8

    opcode_jump = @@opcode_map[opcode]

    modes = parse_modes instructs
    positions, params = position_and_params modes

    puts "c: #{@c}, #{@m[@c, opcode_jump]}" if @debug
    puts "instructs: #{instructs}, opcode: #{opcode}" if @debug
    puts "modes: #{modes}, positions: #{positions}, params: #{params}" if @debug

    should_opcode_jump = true

    case opcode
    when 1
      @m[positions[2]] = params[0] + params[1]
    when 2
      @m[positions[2]] = params[0] * params[1]
    when 3
      int = args.shift
      @m[positions[0]] = int
    when 4
      @output << params[0]
    when 5
      # if first param is non-zero, pointer should be second param
      if params[0] != 0
        should_opcode_jump = false
        @c = params[1]
      end
    when 6
      # if first param is zero, pointer should be second param
      if params[0] == 0
        should_opcode_jump = false
        @c = params[1]
      end
    when 7
      # if the first parameter is less than the second parameter,
      # store 1 in the position given by the third parameter, otherwise store 0
      @m[positions[2]] = params[0] < params[1] ? 1 : 0
    when 8
      # greater than
      # if the first parameter is equal to the second parameter,
      # store 1 in the position given by the third parameter, otherwise store 0
      @m[positions[2]] = params[0] == params[1] ? 1 : 0
    end

    @c += opcode_jump if should_opcode_jump
  end

  def run(args)
    @c = 0
    @m = @machine.clone
    @output = [] of Int32

    until @m[@c] == 99
      cycle args
    end

    return @output
  end
end

m = [] of Int32

STDIN.each_line do |line|
  line.split(",").each do |i|
    m.push i.to_i32
  end
end

highest = -1

[0,1,2,3,4].permutations.each do |phases|
  last_result = 0
  (0..4).each do |i|
    machine = IntM.new m
    args = [phases[i].to_i, last_result]
    last_result = machine.run(args)[0]
  end
  if last_result > highest
    highest = last_result 
  end
  last_result = 0
end

puts highest
