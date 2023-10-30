module SubtractionEquationConcern
  extend ActiveSupport::Concern

  included do
    # minuend - subtrahend = difference
    def generate_subtraction_numbers(
      minuend_range,
      subtrahend_range,
      difference_range
    )
      minuend = random.rand(minuend_range)

      calculated_multiplicand_range =
        calculate_difference_range(minuend, subtrahend_range, difference_range)

      difference = random.rand(calculated_multiplicand_range)

      subtrahend = minuend - difference
      [minuend, subtrahend]
    end

    def calculate_difference_range(minuend, subtrahend_range, difference_range)
      min = minuend - subtrahend_range.max
      min = difference_range.min if min < difference_range.min

      max = minuend - subtrahend_range.min
      max = difference_range.max if max > difference_range.max

      raise RangeError, "Difference range is invalid" if min > max

      min..max
    end
  end
end
