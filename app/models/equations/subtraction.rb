module Equations
  class Subtraction
    include ActiveModel::API
    include ActiveModel::Attributes
    include RandomInRange

    attribute :count_min
    attribute :count_max
    attribute :from
    attribute :to
    attribute :result_min
    attribute :result_max
    attribute :numbers
    attribute :result
    attribute :random

    def initialize(attributes = {})
      super

      initialize_numbers
    end

    def type
      :subtraction
    end

    private

    def initialize_numbers
      loop do
        number_count = random_in_range(count_min, count_max, random: random)
        self.numbers = number_count.times.map do
          random_in_range(from, to, random: random)
        end

        self.result = numbers.inject(:-)

        break if result_min.present? && result >= result_min
        break if result_max.present? && result <= result_max
      end
    end
  end
end
