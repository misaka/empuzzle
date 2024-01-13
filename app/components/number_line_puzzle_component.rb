class NumberLinePuzzleComponent < ViewComponent::Base
  attr_reader :puzzle, :show_answers

  def initialize(puzzle:, show_answers: false)
    super

    @puzzle = puzzle
    @show_answers = show_answers
  end
end
