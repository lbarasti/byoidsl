require "pars3k"
require "dataclass"

include Pars3k

module IGOL
  extend self

  abstract class Command; end
  class Show < Command; end

  dataclass Evolve{n : Int32} < Command
  dataclass VarName{name : String}
  dataclass Pattern{pattern : String}
  dataclass SetVar{name : VarName, pattern : Pattern} < Command
  dataclass Apply{coord : {Int32, Int32}, pattern : VarName | Pattern} < Command

  def ws
    Parse.many_of(Parse.char(' '))
  end

  def var_parser
    Parse.join(
      Parse.one_or_more_of(Parse.alphabet | Parse.digit))
      .transform { |name| VarName.new(name).as(VarName | Pattern) }
  end

  def pattern_parser
    Parse.join(
      Parse.one_or_more_of(Parse.char('.') | Parse.char('*')))
      .transform { |pat| Pattern.new(pat).as(VarName | Pattern) }
  end

  def coord_parser
    do_parse({
      _ <= Parse.char('('),
      x <= Parse.int,
      _ <= ws,
      _ <= Parse.char(','),
      _ <= ws,
      y <= Parse.int,
      _ <= Parse.char(')'),
      Parse.constant({x, y})
    })
  end

  def show_parser
    Parse.string("show").transform { Show.new.as(Command) }
  end

  def evolve_parser
    do_parse({
      _ <= Parse.string("evolve"),
      _ <= Parse.char(' '),
      _ <= ws,
      n <= Parse.int,
      Parse.constant(Evolve.new(n).as(Command))
    })
  end

  def set_var_parser
    do_parse({
      name <= var_parser,
      _ <= Parse.string(": "),
      _ <= ws,
      pattern <= pattern_parser,
      Parse.constant(SetVar.new(name.as(VarName), pattern.as(Pattern)).as(Command))
    })
  end

  def apply_parser
  do_parse({
    coord <= coord_parser,
    _ <= ws,
    _ <= Parse.string("<-"),
    _ <= ws,
    var_or_patter <= var_parser | pattern_parser,
    Parse.constant(Apply.new(coord, var_or_patter).as(Command))
  })
  end

  def igol_parser
    show_parser | evolve_parser | set_var_parser | apply_parser
  end
end
