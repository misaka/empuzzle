# frozen_string_literal: true

class NumberLineFormComponent < ViewComponent::Base
  attr_reader :puzzle

  def initialize(puzzle:)
    super

    @puzzle = puzzle
  end

  def cell_component_class(type:)
    { addition: AdditionCellComponent, division: DivisionCellComponent }[
      type.to_sym
    ]
  end
end
