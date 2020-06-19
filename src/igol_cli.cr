require "./lib/repl"
require "./lib/runtime"
require "./igol"

history_file = "#{Dir.current}/history.log"

runtime = IGOL.runtime

Repl.new(history: history_file) { |input|
  runtime.run(input)
}
