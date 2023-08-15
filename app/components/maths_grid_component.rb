# frozen_string_literal: true

class MathsGridComponent < ViewComponent::Base
  attr_reader :puzzle

  def initialize(puzzle:)
    super

    @puzzle = puzzle
  end
end
