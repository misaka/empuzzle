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

  def puzzle_addition_numbers_options(puzzle)
    puzzle.class::ADDITION_NUMBERS_OPTIONS.map.with_index do |option, idx|
      ["#{option[:count_min]} - #{option[:count_max]}", idx]
    end
  end

  def puzzle_addition_number_counts(puzzle)
    puzzle.class::ADDITION_NUMBER_COUNT_OPTIONS.map.with_index do |option, idx|
      ["#{option[:count_min]} - #{option[:count_max]}", idx]
    end
  end

  def puzzle_addition_number_ranges(puzzle)
    puzzle.class::ADDITION_NUMBER_RANGE_OPTIONS.map.with_index do |option, idx|
      ["#{option[:range_start]} - #{option[:range_end]}", idx]
    end
  end

  def puzzle_subtraction_number_counts(puzzle)
    puzzle.class::SUBTRACTION_NUMBER_COUNT_OPTIONS.map.with_index do |option, idx|
      ["#{option[:count_min]} - #{option[:count_max]}", idx]
    end
  end

  def puzzle_subtraction_number_ranges(puzzle)
    puzzle.class::SUBTRACTION_NUMBER_RANGE_OPTIONS.map.with_index do |option, idx|
      ["#{option[:range_start]} - #{option[:range_end]}", idx]
    end
  end

  def puzzle_multiplication_number_counts(puzzle)
    puzzle.class::MULTIPLICATION_NUMBER_COUNT_OPTIONS.map.with_index do |option, idx|
      ["#{option[:count_min]} - #{option[:count_max]}", idx]
    end
  end

  def puzzle_multiplication_number_ranges(puzzle)
    puzzle.class::MULTIPLICATION_NUMBER_RANGE_OPTIONS.map.with_index do |option, idx|
      ["#{option[:range_start]} - #{option[:range_end]}", idx]
    end
  end

  def puzzle_divisors_ranges(puzzle)
    puzzle.class::DIVISORS_RANGE_OPTIONS.map.with_index do |option, idx|
      ["#{option[:divisors_min]} - #{option[:divisors_max]}", idx]
    end
  end

  def puzzle_dividends_ranges(puzzle)
    puzzle.class::DIVIDENDS_RANGE_OPTIONS.map.with_index do |option, idx|
      ["#{option[:dividends_min]} - #{option[:dividends_max]}", idx]
    end
  end
end
