require "./spec_helper"

include IGOL

describe "IGOL.interpret" do
  state = State.new(
    {"a" => Pattern.new("..**.*")},
    GameOfLife.new(Set{ {0, 0}, {1, 0}, {2, 0}, {0, 1} }))

  describe Show do
    cmd = Show.new
    state_2, output = IGOL.interpret(state, cmd)
    it "is idempotent" do
      state_2.should eq state
    end
    it "should return a drawing of the grid" do
      output.should eq state.grid.draw
    end
  end

  describe SetVar do
    var_name, pattern = "x", Pattern.new("**.")
    cmd = SetVar.new(VarName.new(var_name), pattern)
    state_2, output = IGOL.interpret(state, cmd)

    it "should return a message including variable name and pattern" do
      output.should contain var_name
      output.should contain pattern.pattern
    end

    it "adds a variable to the runtime state" do
      state_2.variables.keys.should contain var_name
      state_2.variables[var_name].should eq pattern
      state_2.variables.should eq state.variables.merge({var_name => pattern})
    end

    it "overwrites the previous value if the specified variable already exists" do
      cmd_2 = SetVar.new(VarName.new(var_name), Pattern.new(".***"))
      state_3, _ = IGOL.interpret(state_2, cmd_2)
      state_3.variables.keys.should eq state_2.variables.keys
      state_3.variables[var_name].pattern.should_not eq pattern
    end
  end

  describe Evolve do
    cmd = Evolve.new(2)
    state_ev2, output = IGOL.interpret(state, cmd)
    it "should return a drawing of the evolved grid" do
      output.should eq state_ev2.grid.draw
    end
    it "evolves the state of the GoL grid" do
      state_ev2.variables.should eq state.variables
      state_ev2.grid.should_not eq state.grid
    end
    it "runs as many iterations as specified in the Evolve command" do
      state_ev1a, output = IGOL.interpret(state, Evolve.new(1))
      state_ev1a.should_not eq state_ev2
      state_ev1b, output = IGOL.interpret(state_ev1a, Evolve.new(1))
      state_ev1b.should eq state_ev2
    end
  end

  describe Apply do
    pattern = ".**.*"
    cmd = Apply.new({-3, 2}, Pattern.new(pattern))
    state_2, output = IGOL.interpret(state, cmd)

    it "applies the given pattern to a set of consecutive cells" do
      output.should eq state_2.grid.draw
      state.grid.draw.should_not contain pattern
      state_2.grid.draw.should_not contain pattern
      state_2.grid.should eq state.grid.add(Set{ {-2, 2}, {-1, 2}, {1, 2} })
    end

    it "supports variables" do
      cmd_2 = Apply.new({-3, 2}, VarName.new("a"))
      pattern_a = state_2.variables["a"]
      active_a, passive_a = pattern_a.apply({-3, 2})
      state_3, _ = IGOL.interpret(state, cmd_2)
      state_3.grid.should eq state_2.grid.add(active_a).remove(passive_a)
    end

    it "should raise an error if the variable is not defined" do
      cmd_2 = Apply.new({-3, 2}, VarName.new("x"))
      expect_raises(Exception, "Undefined variable: x") {
        state_3, _ = IGOL.interpret(state, cmd_2)
      }
    end
  end
end
