require "./game_of_life"
require "./commands"

module IGOL
  def self.interpret(state : GameOfLife, command : Command) : {GameOfLife, String}
    case command
    when Show
      {state, state.draw}
    when Evolve
      new_state = state.evolve(command.n)
      {new_state, new_state.draw}
    when Apply
      coord = command.coord
      case pattern = command.pattern
      when Pattern
        live, dead = pattern.apply(coord)
        new_state = state.add(live).remove(dead)
        {new_state, new_state.draw}
      when VarName
        raise Exception.new("Unsupported command")
      else
        raise Exception.new("Unknown command")
      end
    when SetVar
      raise Exception.new("Unsupported command")
    else
      raise Exception.new("Unknown command")
    end
  end
end
