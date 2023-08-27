# frozen_string_literal: true

module Puzzles
  class MathsGrid::AdditionEquation
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

      initialize_numbers if result.blank?
    end

    def type
      :addition
    end

    def to_h
      { numbers:, result:, type: }
    end

    def self.from_h(hash)
      new(**hash.slice("numbers", "result"))
    end

    private

    def initialize_numbers
      10.times do |n|
        number_count = random.rand(count)
        self.numbers = number_count.times.map { random.rand(range) }

        self.result = numbers.inject(:+)

        Rails.logger.debug "+++ [##{n}] #{numbers.join(" + ")} = #{result} ;" \
                             " #{result_range&.min} < #{result} < #{result_range&.max}"

        return if valid_result? # rubocop:disable Lint/NonLocalExitFromIterator
      end

      raise "Could not generate valid result"
    end

    def valid_result?
      @result_range.blank? || @result_range.include?(result)
    end
  end
end
