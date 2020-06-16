require "dataclass"
require "../lib/runtime"

module Counter
  dataclass CounterState{value : Int32}
  abstract struct Op; end
  record Plus < Op
  record Minus < Op
  record Er, reason : String

  def self.parse(input : String) : Op | Er
    if input == "+"
      Plus.new
    elsif input == "-"
      Minus.new
    else
      Er.new("Unknown operation")
    end
  end

  def self.interpret(state : CounterState, op : Op) : {CounterState, String}
    new_val = case op
    when Plus
      state.value + 1
    when Minus
      state.value - 1
    else
      raise Exception.new("Unknown operation")
    end
    {state.copy(value: new_val), "count: #{new_val}"}
  end

  def self.runtime
    state = CounterState.new(0)
    parser_fn = ->Counter.parse(String)
    interpreter_fn = ->Counter.interpret(CounterState, Op)

    Runtime(CounterState, Op, Er)
      .new(state, parser_fn, interpreter_fn)
  end
end