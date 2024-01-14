# frozen_string_literal: true

class MathsArithmeticGridComponent < ViewComponent::Base
  attr_reader :maths_grid, :show_answers

  def initialize(puzzle:, show_answers: false)
    super

    @maths_grid = puzzle
    @show_answers = show_answers
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
