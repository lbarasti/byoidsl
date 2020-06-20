require "clim"
require "./repl"

module CLI
  macro run(mod)
    class {{mod}}_CLI < Clim
      main do
        desc "{{mod}} interpreter"
        usage {{mod.stringify.downcase}} + " [option] [filepath]"
        version "Version #{{{mod}}.version}", short: "-v"
        help short: "-h"
        argument "filepath", type: String, desc: "path to {{mod}} script"

        run do |_, args|
          runtime = {{mod}}.runtime
          
          if filepath = args.filepath
            File.each_line(filepath) { |input|
              output = runtime.run(input)
              puts output unless output.nil?
            }
          else
            history_file = "#{Dir.current}/history.log"
            Repl.new(history: history_file) { |input|
              runtime.run(input)
            }
          end
        end

      end
    end

    {{mod}}_CLI.start(ARGV)
  end
end