require "fancyline"

class Repl
  def initialize(history : String, &process : String -> _)
    fancy = Fancyline.new
    Repl.load_history(fancy, history)
    
    while input = fancy.readline("$ ") # Ask the user for input
      begin
        if input.starts_with?("%load")
          filepath = input.lchop("%load").strip
          File.each_line(filepath) { |line|
            Repl.eval_and_print process, line
          }
        else
          Repl.eval_and_print process, input
        end
      rescue ex : Exception
        puts "error: #{ex}"
      end
    end
  rescue ex : Fancyline::Interrupt
    puts "Shutting down..."
  ensure
    Repl.write_history(fancy, history)
  end

  def self.eval_and_print(process, input)
    output = process.call input
    puts output if output
  end

  def self.load_history(fancy, history)
    if File.exists? history
      puts "  Reading history from #{history}"
      File.open(history, "r") do |io|
        fancy.history.load io
      end
    end
  end

  def self.write_history(fancy, history)
    File.open(history, "w") do |io| # So open it writable
      fancy.not_nil!.history.save io # And save.  That's it.
    end
  end
end
