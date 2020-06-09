require "dataclass"

module IGOL
  alias Point = {Int32, Int32}
  
  # Represents a mutable GoL grid
  dataclass GameOfLife{population : Set(Point) = Set(Point).new} do
    OriginSquare = [
      {-1,  1}, {0,  1}, {1,  1},
      {-1,  0}, {0,  0}, {1,  0},
      {-1, -1}, {0, -1}, {1, -1}
    ]

    protected def self.expand(point : Point)
      OriginSquare.map { |(x, y)| {point.first + x, point.last + y} }
    end

    def evolve(iterations = 1)
      pop = @population
      iterations.times {
        pop = pop.flat_map { |cell| {{@type}}.expand(cell) }
          .tally
          .select { |cell, count| count == 3 || (count == 4 && pop.includes?(cell)) }
          .keys.to_set
      }
      GameOfLife.new(pop)
    end

    def remove(cells : Set(Point))
      GameOfLife.new(@population - cells)
    end

    def add(cells : Set(Point))
      GameOfLife.new(@population | cells)
    end

    def draw(x_range = -4..4, y_range = -4..4)
      y_range.reverse_each.map { |y|
        x_range.map { |x| @population.includes?({x, y}) ? "o" : "-" }.join
      }.join("\n")
    end

    def self.random(max_size = 100, x_range = 1..10, y_range = 1..10)
      GameOfLife.new (1..max_size).map{ {rand(x_range), rand(y_range)} }.to_set
    end
  end
end
