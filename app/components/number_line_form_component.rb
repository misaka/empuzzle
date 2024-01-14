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

  def sizes_for_select
    @puzzle.sizes.map do |name, setting|
      dimensions =
        I18n.t(
          "puzzles.maths.number_line_arithmetic.dimensions",
          rows: setting[:rows]
        )
      ["#{name.capitalize} (#{dimensions})", name]
    end
  end
end
