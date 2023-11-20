# frozen_string_literal: true

class NumberLineMathsFormComponent < ViewComponent::Base
  attr_reader :number_line_maths

  def initialize(puzzle:)
    super

    @number_line_maths = puzzle
  end

  def cell_component_class(type:)
    { addition: AdditionCellComponent, division: DivisionCellComponent }[
      type.to_sym
    ]
  end
end
