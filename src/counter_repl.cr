require "./lib/repl"
require "./lib/runtime"
require "./counter"

history_file = "#{Dir.current}/history.log"

runtime = Counter.runtime

Repl.new(history: history_file) { |input|
  runtime.run(input)
}
