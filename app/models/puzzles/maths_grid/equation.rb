# frozen_string_literal: true

module Puzzles
  class MathsGrid::Equation
    include ActiveModel::API
    include ActiveModel::Attributes

    # attribute :count
    attribute :range
    attribute :type
    attribute :result_range
    attribute :result_decimal_places, default: 0
    attribute :numbers
    attribute :result
    attribute :random

    def initialize(attributes = {})
      super

      if result.blank?
        if range.is_a? Array
          if range.length != 2
            raise "when range is an array it's length must be 2"
          end
        end

        initialize_numbers
      end

    end

    def to_h
      Rails.logger.info("equation type: #{type}")

      { numbers:, result:, type: }
    end

    def self.from_h(hash)
      new(**hash.slice("numbers", "result", "type"))
    end

    private

    def operator
      {
        "addition" => :+,
        "subtraction" => :-,
        "multiplication" => :*,
        "division" => :/
      }[type.to_s]
    end

    def initialize_numbers
      ranges = range.is_a?(Array) ? range : [range] * 2

      10.times do |n|
        self.numbers = ranges.map { |r| random.rand(r) }

        self.result = numbers.inject(operator)

        Rails.logger.debug "#{operator.to_s * 3} [##{n}] #{numbers.join(" #{operator} ")} = #{result} ;" \
                             " #{result_range&.min} < #{result} < #{result_range&.max}"

        return if valid_result? # rubocop:disable Lint/NonLocalExitFromIterator
      end

      raise "Could not generate valid result"
    end

    def valid_result?
      result.round(result_decimal_places) == result &&
        (result_range.blank? || result_range.include?(result))

      @result_range.blank? || @result_range.include?(result)
    end
  end
end
