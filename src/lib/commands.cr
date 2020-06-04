require "dataclass"

module IGOL
  abstract class Command; end
  class Show < Command; end

  dataclass Evolve{n : Int32} < Command
  dataclass VarName{name : String}
  dataclass Pattern{pattern : String} do
    @active : Array(Int32)
    @passive : Array(Int32)

    def initialize(@pattern : String)
      @active, @passive = pattern.split("").map_with_index { |c, i|
        {i, c != "."}
      }.partition(&.last)
      .map(&.map(&.first))
    end

    def apply(coord : {Int32, Int32})
      {@active, @passive}.map { |xs| xs.map { |i| {coord.first + i, coord.last} }.to_set }
    end
  end
  dataclass SetVar{name : VarName, pattern : Pattern} < Command
  dataclass Apply{coord : {Int32, Int32}, pattern : VarName | Pattern} < Command
end
