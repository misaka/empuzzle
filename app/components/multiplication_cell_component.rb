# frozen_string_literal: true

class MultiplicationCellComponent < ViewComponent::Base
  attr_reader :equation, :maths_grid

  def initialize(equation:, maths_grid:)
    super

    @equation = equation
    @maths_grid = maths_grid
  end

  def results_max_length
    @maths_grid
      .cells
      .grep(Puzzles::MathsGrid::MultiplicationEquation)
      .map(&:result)
      .max
      .to_s
      .length
  end
end
