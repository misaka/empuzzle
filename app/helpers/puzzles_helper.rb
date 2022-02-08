module PuzzlesHelper
  def puzzle_addition_results_max_length(puzzle)
    puzzle.grep(Equations::Addition).map(&:result).reduce(&:+).to_s.length
  end
end
