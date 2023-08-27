# frozen_string_literal: true

class MathsGridComponent < ViewComponent::Base
  attr_reader :maths_grid

  def initialize(puzzle:)
    super

    @maths_grid = puzzle
  end

  def cell_component_class(type:)
    case type
    when :addition
      AdditionCellComponent
    when :division
      DivisionCellComponent
    when :multiplication
      MultiplicationCellComponent
    when :subtraction
      SubtractionCellComponent
    end
  end
end
