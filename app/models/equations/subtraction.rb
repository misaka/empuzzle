# frozen_string_literal: true

# rubocop:disable Style/RedundantSelf
module Equations
  class Subtraction
    include ActiveModel::API
    include ActiveModel::Attributes

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

    def to_h
      {
        numbers:,
        result:,
        type:,
      }
    end

    def from_h(hash)
      self.numbers = hash["numbers"]
      self.result = hash["result"]
    end

  private

    def initialize_numbers
      10.times do |n|
        number_count = random.rand(count)
        self.numbers = number_count.times.map { random.rand(range) }

        self.result = numbers.inject(:-)

        Rails.logger.debug "+++ [##{n}] #{self.numbers.join(' - ')} = #{result} ;" \
          " #{result_range&.min} < #{result} < #{result_range&.max}"

        return if valid_result? # rubocop:disable Lint/NonLocalExitFromIterator
      end

      raise "Could not generate valid result"
    end

    def valid_result?
      result_range.present? && result_range.include?(result)
    end
  end
end
# rubocop:enable Style/RedundantSelf
