module SubtractionEquationGeneratorConcern
  extend ActiveSupport::Concern

  class_methods do
    # minuend - subtrahend = difference
    def generate_subtraction_numbers(
      minuend_range:,
      subtrahend_range:,
      difference_range:,
      random:
    )
      minuend = random.rand(minuend_range)

      subtrahend_range ||= minuend_range
      calculate_subtrahend_range =
        calculate_subtrahend_range(
          minuend,
          minuend_range,
          subtrahend_range,
          difference_range
        )
      subtrahend = random.rand(calculate_subtrahend_range)

      [minuend, subtrahend]
    end

    def calculate_subtrahend_range(
      minuend,
      _minuend_range,
      subtrahend_range,
      difference_range
    )
      return subtrahend_range if difference_range.blank?

      min = minuend - difference_range.max
      min = subtrahend_range.min if min < subtrahend_range.min

      max = minuend - difference_range.min
      max = subtrahend_range.max if max > subtrahend_range.max

      if min > max
        raise RangeError,
              "Subtrahend range is invalid, #{min} cannot be more than #{max}"
      end

      min..max
    end
  end
end
