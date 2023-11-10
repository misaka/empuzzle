# frozen_string_literal: true

class SubtractionCellComponent < ViewComponent::Base
  attr_reader :equation, :maths_grid

  def initialize(equation:, maths_grid:)
    super

    @equation = equation
    @maths_grid = maths_grid
  end
end
