# frozen_string_literal: true

module Equations
  class Division
    include ActiveModel::API
    include ActiveModel::Attributes
    include RandomInRange

    attribute :dividends_range
    attribute :divisors_range
    attribute :result_decimal_places
    attribute :result_range
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
      10.times do |n|
        self.dividend = random_in_range(dividends_range.min, dividends_range.max, random: random).to_f
        self.divisor  = random_in_range(divisors_range.min, divisors_range.max, random: random).to_f

        self.result = dividend / divisor

        Rails.logger.debug "/// [##{n}] #{self.dividend} ÷ #{self.divisor} = #{result}" +
                           (result_range.present? ? " ; #{result_range.min} < #{result} < #{result_range.max}" : "")

        return if valid_result?
      end

      raise "Could not generate valid result"
    end

    def valid_result?
      result.round(result_decimal_places) == result &&
        (result_range.blank? || result_range.include?(result))
    end
  end
end
