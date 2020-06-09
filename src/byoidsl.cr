require "./lib/repl"
require "./lib/parser"
require "./lib/interpreter"
require "./lib/game_of_life"

include IGOL

history_file = "#{Dir.current}/history.log"
state = GameOfLife.new(Set{ {0,0}, {1,0}, {2,0}, {0,1} })

Repl.new(history: history_file) { |input|
  command = IGOL.igol_parser.parse(input)
  case command
  when Command
    state, output = IGOL.interpret(state, command)
    puts output
  else
    puts "Syntax error: #{command}"
  end
}