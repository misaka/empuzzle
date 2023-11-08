module DivisionEquationGeneratorConcern
  extend ActiveSupport::Concern

  class_methods do
    # dividend / divisor = quotient
    def generate_division_numbers(
      divisor_range:,
      quotient_range:,
      random:,
      dividend_range: nil
    )
      divisor = random.rand(divisor_range)

      quotient =
        random.rand(
          calculate_quotient_range(dividend_range, divisor, quotient_range)
        )

      dividend = quotient * divisor

      [dividend, divisor]
    end

    def calculate_quotient_range(dividend_range, divisor, quotient_range)
      return quotient_range unless dividend_range

      min = (dividend_range.min / divisor.to_f).ceil
      min = [quotient_range.min, min].max if quotient_range

      max = (dividend_range.max / divisor.to_f).floor
      max = [quotient_range.max, max].min if quotient_range

      raise RangeError, "Quotient range is invalid" if min > max

      min..max
    end
  end
end
