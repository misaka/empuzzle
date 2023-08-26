# frozen_string_literal: true

module Equations
  class Addition
    include ActiveModel::API
    include ActiveModel::Attributes
    include RandomInRange

    attribute :count
    attribute :range
    attribute :result_range
    attribute :numbers
    attribute :result
    attribute :random

    def initialize(attributes = {})
      super

      initialize_numbers
    end

    def type
      :addition
    end

  private

    def initialize_numbers
      loop do
        number_count = random_in_range(count.min, count.max, random: random)
        self.numbers = number_count.times.map do
          random_in_range(range.min, range.max, random: random)
        end

        self.result = numbers.inject(:+)

        Rails.logger.debug("+++ #{result_range&.min} < #{result} < #{result_range&.max}")

        next if result_range&.min.present? && result < result_range.min
        next if result_range&.max.present? && result > result_range.max

        break
      end
    end
  end
end
