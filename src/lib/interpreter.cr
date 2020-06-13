require "./state"
require "./commands"

module IGOL
  def self.interpret(state : State, command : Command) : {State, String}
    case command
    when Show
      {state, state.grid.draw}
    when Evolve
      new_grid = state.grid.evolve(command.n)
      new_state = state.copy(grid: new_grid)
      {new_state, new_grid.draw}
    when Apply
      coord = command.coord
      pattern = case pattern_or_var = command.pattern
      when Pattern
        pattern_or_var
      when VarName
        var_name = pattern_or_var.name
        if ptr = state.variables[var_name]?
          ptr
        else
          raise Exception.new("Undefined variable: #{var_name}")
        end
      else
        raise Exception.new("Unknown command")
      end
      live, dead = pattern.apply(coord)
      new_grid = state.grid.add(live).remove(dead)
      new_state = state.copy(grid: new_grid)
      {new_state, new_grid.draw}
    when SetVar
      var_name = command.name.name
      pattern = command.pattern
      new_variables = state.variables.merge({ var_name => pattern })
      new_state = state.copy(variables: new_variables)
      {new_state, "#{var_name} set to #{pattern.pattern}"}
    else
      raise Exception.new("Unknown command")
    end
  end
end
