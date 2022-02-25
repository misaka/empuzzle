module Equations
  class Division
    include ActiveModel::API
    include ActiveModel::Attributes
    include RandomInRange

    attribute :dividends_min
    attribute :dividends_max
    attribute :divisors_min
    attribute :divisors_max
    attribute :result_min
    attribute :result_max
    attribute :dividend
    attribute :divisor
    attribute :result
    attribute :random

    def initialize(attributes = {})
      super

      initialize_numbers
    end

    def type
      :division
    end

    private

    def initialize_numbers
      loop do
        self.dividend = random_in_range(dividends_min, dividends_max, random: random)
        self.divisor  = random_in_range(divisors_min, divisors_max, random: random)

        self.result = dividend / divisor

        break if result_min.present? && result >= result_min
        break if result_max.present? && result <= result_max
      end
    end
  end
end
