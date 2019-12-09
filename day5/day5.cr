class IntM
  @@opcode_map = {
    1 => 4,
    2 => 4,
    3 => 2,
    4 => 2,
  }

  @m : Array(Int32)
  @debug : Bool

  def initialize(@machine : Array(Int32))
    @m = [] of Int32
    @debug = (ENV["DEBUG"] ||= "false") == "true"
    @c = 0
  end

  # parse the remaining mode instructions, including the potential omitted params
  def parse_modes(instructs)
    modes = instructs.chars.map { |instru| instru.to_i }
    modes.pop 2
    modes.reverse
  end

  def position_and_params(modes)
    # make a note of both the actual positions and values of the items
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

  def run(args)
    @c = 0
    @m = @machine.clone

    until @m[@c] == 99
      # parse out the opcode, the right-most two digits
      instructs = @m[@c].to_s
      opcode = instructs[instructs.size - 2, instructs.size].to_i
      raise "opcode more than 4!" if opcode > 4

      opcode_jump = @@opcode_map[opcode]

      modes = parse_modes instructs
      positions, params = position_and_params modes

      puts "instructs: #{instructs}, opcode: #{opcode}" if @debug
      puts "modes: #{modes}, positions: #{positions}, params: #{params}" if @debug

      case opcode
      when 1
        @m[positions[2]] = params[0] + params[1]
      when 2
        @m[positions[2]] = params[0] * params[1]
      when 3
        int = args.shift
        @m[positions[0]] = int
      when 4
        puts params[0]
      end

      @c += opcode_jump
    end
  end
end

m = [] of Int32

STDIN.each_line do |line|
  line.split(",").each do |i|
    m.push i.to_i32
  end
end

args = [1]

machine = IntM.new m
machine.run args
