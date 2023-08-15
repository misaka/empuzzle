# frozen_string_literal: true

module Equations
  class Multiplication
    include ActiveModel::API
    include ActiveModel::Attributes
    include RandomInRange

    attribute :count_min
    attribute :count_max
    attribute :range_start
    attribute :range_end
    attribute :result_min
    attribute :result_max
    attribute :random
    attribute :factors
    attribute :result

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
          random_in_range(range_start, range_end, random: random)
        end

        self.result = factors.inject(:*)

        Rails.logger.debug("*** #{result_min} < #{result} < #{result_max}")

        next if result_min.present? && result < result_min
        next if result_max.present? && result > result_max

        break
      end
    end
  end
end
