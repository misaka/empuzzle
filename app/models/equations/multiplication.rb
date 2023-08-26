# frozen_string_literal: true

module Equations
  class Multiplication
    include ActiveModel::API
    include ActiveModel::Attributes
    include RandomInRange

    attribute :count
    attribute :range
    attribute :result_range
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
      10.times do |n|
        factor_count = random_in_range(count.min, count.max, random:)
        self.factors = factor_count.times.map do
          random_in_range(range.min, range.max, random:)
        end

        self.result = factors.inject(:*)

        Rails.logger.debug "*** [##{n}] #{self.factors.join(" * ")} = #{result}" +
                           (result_range.present? ? " ; #{result_range.min} < #{result} < #{result_range.max}" : "")

        return if valid_result?
      end

      raise "Could not generate valid result"
    end

    def valid_result?
      result_range.blank? || result_range.include?(result)
    end
  end
end
