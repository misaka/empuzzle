module PuzzlesHelper
  def puzzle_subtraction_results_max_length(puzzle)
    puzzle.grep(Equations::Subtraction).map(&:result).max.to_s.length
  end

  def puzzle_addition_results_max_length(puzzle)
    puzzle.grep(Equations::Addition).map(&:result).max.to_s.length
  end

  def puzzle_multiplication_results_max_length(puzzle)
    puzzle.grep(Equations::Multiplication).map(&:result).max.to_s.length
  end
end
