module AdditionEquationConcern
  extend ActiveSupport::Concern

  included do
    # augend + addend = sum
    def generate_addition_numbers(augend_range, addend_range, sum_range)
      augend = random.rand(augend_range)

      calculated_addend_range =
        calculate_addend_range(augend, addend_range, sum_range)

      addend = random.rand(calculated_addend_range)

      [augend, addend]
    end

    def calculate_addend_range(augend, addend_range, sum_range)
      return addend_range unless sum_range

      min = sum_range.min - augend
      min = addend_range.min if min < addend_range.min

      max = sum_range.max - augend
      max = addend_range.max if max > addend_range.max

      raise RangeError, "Addend range is invalid" if min > max

      min..max
    end
  end
end
