class Runtime(State, Cmd, Err)
  def initialize(
    @state : State,
    @parser : String -> Cmd | Err,
    @interpreter : State, Cmd -> {State, String})
  end

  def run(input : String)
    command = @parser.call(input)
    case command
    when Cmd
      @state, output = @interpreter.call(@state, command)
      puts output
    else
      puts "Syntax error: #{command}"
    end
  end
end