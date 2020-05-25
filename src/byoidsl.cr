require "./lib/repl"

history_file = "#{Dir.current}/history.log"

Repl.new(history: history_file) { |input|
  puts input
}