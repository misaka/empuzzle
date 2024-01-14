# frozen_string_literal: true

class MathsGridFormComponent < ViewComponent::Base
  attr_reader :puzzle

  def initialize(puzzle:)
    super

    @puzzle = puzzle
  end

  private

  def level_config
    @puzzle.level_config
  end

  def sizes_for_select
    @puzzle.sizes.map do |name, setting|
      dimensions =
        I18n.t(
          "puzzles.maths.arithmetic_grid.dimensions",
          cols: setting[:columns],
          rows: setting[:rows]
        )
      ["#{name.capitalize} (#{dimensions})", name]
    end
  end
end
