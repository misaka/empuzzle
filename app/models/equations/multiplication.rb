# frozen_string_literal: true

module Equations
  class Multiplication
    include ActiveModel::API
    include ActiveModel::Attributes

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

    def to_h
      {
        factors:,
        result:,
        type:,
      }
    end

    def from_h(hash)
      self.factors = hash["factors"]
      self.result = hash["result"]
    end

  private

    def initialize_factors
      10.times do |n|
        factor_count = random.rand(count)
        self.factors = factor_count.times.map { random.rand(range) }

        self.result = factors.inject(:*)

        Rails.logger.debug "*** [##{n}] #{factors.join(' * ')} = #{result}" +
          (result_range.present? ? " ; #{result_range.min} < #{result} < #{result_range.max}" : "")

        return if valid_result? # rubocop:disable Lint/NonLocalExitFromIterator
      end

      raise "Could not generate valid result"
    end

    def valid_result?
      result_range.blank? || result_range.include?(result)
    end
  end
end
