# frozen_string_literal: true

module Puzzles
  class MathsGrid::Equation
    include ActiveModel::API
    include ActiveModel::Attributes
    include SubtractionEquationConcern
    include MultiplicationEquationConcern

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
        if range.is_a?(Array) && (range.length != 2)
          raise "when range is an array it's length must be 2"
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
      }[
        type.to_s
      ]
    end

    def initialize_numbers
      ranges = range.is_a?(Array) ? range : [range, range]

      10.times do |n|
        self.numbers = generate_numbers(ranges)

        self.result = generate_result

        Rails.logger.debug "#{operator.to_s * 3} [##{n}] #{numbers.join(" #{operator} ")} = #{result} ;" \
                             " #{result_range&.min} < #{result} < #{result_range&.max}"

        return if valid_result? # rubocop:disable Lint/NonLocalExitFromIterator
      end

      raise "Could not generate valid result"
    end

    def generate_numbers(ranges)
      case type
      when "division"
        generate_division_numbers(*ranges)
      when "multiplication"
        generate_multiplication_numbers(*ranges, result_range)
      when "subtraction"
        generate_subtraction_numbers(*ranges, result_range)
      when "addition", "multiplication"
        ranges.map { |r| random.rand(r) }
      else
        raise ArgumentError, "Unknown equation type: #{type}"
      end
    end

    def generate_division_numbers(dividend_range, divisor_range)
      divisor = random.rand(divisor_range)
      quotient = calculate_quotient(dividend_range, divisor)
      dividend = quotient * divisor

      [dividend, divisor]
    end

    def calculate_quotient(dividend_range, divisor)
      quotient_range_min = dividend_range.min / divisor
      quotient_range_min = 1 if quotient_range_min < 1

      quotient_range_max = dividend_range.max / divisor
      quotient_range = quotient_range_min..quotient_range_max
      random.rand(quotient_range)
    end

    def generate_result
      if type.to_s == "division"
        numbers.map(&:to_f).inject(operator)
      else
        numbers.inject(operator)
      end
    end

    def valid_result?
      result_is_whole_number? && result_in_range?
    end

    def result_is_whole_number?
      result.round(result_decimal_places) == result
    end

    def result_in_range?
      (result_range.blank? || result_range.include?(result))
    end
  end
end
