# frozen_string_literal: true

module Equations
  class Subtraction
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
      :subtraction
    end

  private

    def initialize_numbers
      max_tries = 10
      try = 0
      loop do
        raise "too many tries" if try >= max_tries
        try += 1

        number_count = random_in_range(count.min, count.max, random: random)
        self.numbers = number_count.times.map do
          random_in_range(range.min, range.max, random: random)
        end

        self.result = numbers.inject(:-)

        Rails.logger.debug("--- [#{try}] #{self.numbers.join(" - ")} = #{result} ; #{result_range&.min} < #{result} < #{result_range&.max}")

        next if result_range.present? && result < result_range.min
        next if result_range.present? && result > result_range.max

        break
      end
    end
  end
end
