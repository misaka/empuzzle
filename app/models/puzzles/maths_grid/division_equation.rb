# frozen_string_literal: true

module Puzzles
  class MathsGrid::DivisionEquation
    include ActiveModel::API
    include ActiveModel::Attributes

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

      initialize_numbers if result.blank?
    end

    def type
      :division
    end

    def to_h
      { dividend:, divisor:, result:, type: }
    end

    def self.from_h(hash)
      new(**hash.slice("dividend", "divisor", "result"))
    end

    private

    def initialize_numbers
      10.times do |n|
        self.dividend = random.rand(dividends_range).to_f
        self.divisor = random.rand(divisors_range).to_f

        self.result = dividend / divisor

        Rails.logger.debug "/// [##{n}] #{dividend} ÷ #{divisor} = #{result}" +
                             (
                               if result_range.present?
                                 " ; #{result_range.min} < #{result} < #{result_range.max}"
                               else
                                 ""
                               end
                             )

        return if valid_result? # rubocop:disable Lint/NonLocalExitFromIterator
      end

      raise "Could not generate valid result"
    end

    def valid_result?
      result.round(result_decimal_places) == result &&
        (result_range.blank? || result_range.include?(result))
    end
  end
end
