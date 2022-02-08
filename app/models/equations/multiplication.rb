module Equations
  class Multiplication
    include ActiveModel::API
    include ActiveModel::Attributes
    include RandomInRange

    attribute :count_min
    attribute :count_max
    attribute :from
    attribute :to
    attribute :total_max
    attribute :factors
    attribute :result
    attribute :random

    def initialize(attributes = {})
      super

      initialize_factors
    end

    def type
      :multiplication
    end

    private

    def initialize_factors
      loop do
        factor_count = random_in_range(count_min, count_max, random: random)
        self.factors = factor_count.times.map do
          random_in_range(from, to, random: random)
        end

        self.result = factors.inject(:*)

        break if total_max.nil? || result <= total_max
      end
    end
  end
end
