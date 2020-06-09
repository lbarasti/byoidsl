require "./spec_helper"

include IGOL
# evolve, remove, add, draw, self.random
describe GameOfLife do
  it "can be initialised as an empty grid" do
    grid = GameOfLife.new
    grid.population.should be_empty
  end

  it "can be initialised by providing the active cells" do
    grid = GameOfLife.new Set{ {0, 1}, {1, -3} }
    grid.population.should eq Set{ {0, 1}, {1, -3} }
  end

  it "can be evolved" do
    h3 = Set{ {-1, 0}, {0, 0}, {1, 0} }
    v3 = Set{ {0, 1}, {0, 0}, {0, -1} }
    grid = GameOfLife.new h3
    grid = grid.evolve
    grid.population.should eq v3
    grid = grid.evolve
    grid.population.should eq h3
    grid = grid.evolve 2 * rand(10) + 1
    grid.population.should eq v3
    grid = grid.evolve 2 * rand(10) + 1
    grid.population.should eq h3
  end

  it "can be evolved into a stable configuration" do
    l = Set{ {0, 0}, {1, 0}, {0, 1}, {0, 2} }
    oval = Set{ {-1, 0}, {-1, 1}, {0, -1}, {0, 2}, {1, 0}, {1, 1} }
    grid = GameOfLife.new l
    grid = grid.evolve 3
    grid.population.should eq oval
    grid = grid.evolve rand(10)
    grid.population.should eq oval
  end

  it "supports activating and deactivating cells" do
    grid = GameOfLife.new(Set{ {0, 1}, {-2, 1}, {-3, -3} })
    grid.population.should contain({-2, 1})
    grid.population.should_not contain({6, 6})

    grid = grid.remove(Set{ {-2, 1}, {6, 6} })
    grid.population.should_not contain({-2, 1})
    grid.population.should_not contain({6, 6})
    
    grid = grid.add(Set{ {-3, -2}, {-3, -1} })
    grid.population.should eq Set{ {0, 1}, {-3, -3}, {-3, -2}, {-3, -1} }
  end

  it "can draw the grid" do
    grid = GameOfLife.new Set{ {1, 1}, {1, 2}, {2, 2}, {3, 2} }
    expected_1 = "----\n\
                -ooo\n\
                -o--\n\
                ----"
    expected_2 = "--o-\n\
                  -oo-\n\
                  -o--\n\
                  ----"
    expected_3 = "-oo-\n\
                  o--o\n\
                  -oo-\n\
                  ----"
    grid.draw(0..3, 0..3).should eq expected_1
    grid = grid.evolve
    grid.draw(0..3, 0..3).should eq expected_2
    grid = grid.evolve 3
    grid.draw(0..3, 0..3).should eq expected_3
  end

  it "can generate a random grid" do
    grid = GameOfLife.random(4, x_range: -1..1, y_range: -1..1)
    grid.population.size.should be > 0
    grid.population.size.should be <= 4
    (-1..1).each { |i|
      grid.population.should_not contain({-2, i})
    }
  end
end
