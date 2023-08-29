# frozen_string_literal: true

class MathsGridComponent < ViewComponent::Base
  attr_reader :maths_grid

  def initialize(puzzle:)
    super

    @maths_grid = puzzle
  end

  def cell_component_class(type:)
    {
      addition: AdditionCellComponent,
      division: DivisionCellComponent,
      multiplication: MultiplicationCellComponent,
      subtraction: SubtractionCellComponent
    }[
      type.to_sym
    ]
  end
end
