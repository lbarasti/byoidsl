require "./spec_helper"

include IGOL

describe "IGOL.parser" do
  it "knows how to parse variables, patterns and coordinates" do
    var_parser.parse("a1").should eq VarName.new("a1")
    pattern_parser.parse(".*...*").should eq Pattern.new(".*...*")
    coord_parser.parse("(2, 1)").should eq({2,1})
  end

  it "supports signed coordinates" do
    coord_parser.parse("(-2, 1)").should eq({-2, 1})
    coord_parser.parse("(-2, -1)").should eq({-2, -1})
    coord_parser.parse("(+2, -1)").should eq({+2, -1})
    coord_parser.parse("(2, -1)").should eq({2, -1})
  end

  it "knows how to parse each command" do
    show_parser.parse("show").should be_a Show
    evolve_parser.parse("evolve 72").should eq Evolve.new(72)
    set_var_parser.parse("a1: .*..*").should eq SetVar.new(VarName.new("a1"), Pattern.new(".*..*"))
    apply_parser.parse("(1,22) <- ...*..*").should eq Apply.new({1,22}, Pattern.new("...*..*"))
    apply_parser.parse("(1,   22) <- a2").should eq Apply.new({1,22}, VarName.new("a2"))
  end

  it "parsers commands" do
    parser.parse("show").should be_a(Show)
    parser.parse("evolve 72").should eq Evolve.new(72)
    parser.parse("a1: .*..*").should eq SetVar.new(VarName.new("a1"), Pattern.new(".*..*"))
    parser.parse("(1,22) <- ...*..*").should eq Apply.new({1,22}, Pattern.new("...*..*"))
    parser.parse("(1,   22) <- a2").should eq Apply.new({1,22}, VarName.new("a2"))
  end
end