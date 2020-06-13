require "./lib/repl"
require "./lib/parser"
require "./lib/interpreter"
require "./lib/state"

include IGOL

history_file = "#{Dir.current}/history.log"

grid = GameOfLife.new(Set{ {0,0}, {1,0}, {2,0}, {0,1} })
variables = Hash(String, Pattern).new
state = State.new(variables, grid)

Repl.new(history: history_file) { |input|
  command = IGOL.parser.parse(input)
  case command
  when Command
    state, output = IGOL.interpret(state, command)
    puts output
  else
    puts "Syntax error: #{command}"
  end
}
