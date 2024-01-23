class PuzzleFormComponent < ViewComponent::Base
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
    Puzzle.sizes.map { |(size, _idx)| ["#{size.capitalize}", size] }
  end
end
