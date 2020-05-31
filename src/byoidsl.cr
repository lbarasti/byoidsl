require "./lib/repl"
require "./lib/parser"

history_file = "#{Dir.current}/history.log"

Repl.new(history: history_file) { |input|
  puts IGOL.igol_parser.parse(input)
}