module MultiplicationEquationGeneratorConcern
  extend ActiveSupport::Concern

  class_methods do
    # multiplier x multiplicand = product
    def generate_multiplication_numbers(
      multiplier_range:,
      multiplicand_range: nil,
      product_range: nil,
      decimal_places: 0,
      random:
        )
      multiplicand_range ||= multiplier_range

      multiplier = random.rand(multiplier_range).round(decimal_places)

      multiplicand =
        random.rand(
          calculate_multiplicand_range(
            multiplier,
            multiplicand_range,
            product_range,
            decimal_places
          )
        ).round(decimal_places)

      [multiplier, multiplicand]
    end

    def calculate_multiplicand_range(
      multiplier,
      multiplicand_range,
      product_range,
      decimal_places = 0
    )
      return multiplicand_range if product_range.blank?

      min = (product_range.min.to_f / multiplier).ceil(decimal_places)
      min = [multiplicand_range.min, min].max

      max = (product_range.max.to_f / multiplier).floor(decimal_places)
      max = [multiplicand_range.max, max].min

      raise RangeError, "Product range is invalid" if min > max

      min..max
    end
  end
end
