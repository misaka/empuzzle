# frozen_string_literal: true

class MultiplicationCellComponent < ViewComponent::Base
  attr_reader :equation, :puzzle

  def initialize(equation:, puzzle:)
    super

    @equation = equation
    @puzzle = puzzle
  end
end
