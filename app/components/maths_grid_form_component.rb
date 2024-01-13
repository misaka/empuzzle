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
      ["#{name.capitalize} (#{setting[:columns]} x #{setting[:rows]})", name]
    end
  end
end
