require "../lib/runtime"

module IGOL
  def self.runtime
    grid = GameOfLife.new(Set(Point).new)
    variables = Hash(String, Pattern).new
    state = State.new(variables, grid)
    parser = IGOL.parser
    parser_fn = ->parser.parse(String)
    interpreter_fn = ->IGOL.interpret(State, Command)

    Runtime.new(state, parser_fn, interpreter_fn)
  end
end