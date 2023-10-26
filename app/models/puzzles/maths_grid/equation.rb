# frozen_string_literal: true

module Puzzles
  class MathsGrid::Equation
    include ActiveModel::API
    include ActiveModel::Attributes
    include SubtractionEquationConcern
    include MultiplicationEquationConcern
    include DivisionEquationConcern

    # attribute :count
    attribute :ranges
    attribute :type
    attribute :result_range
    attribute :result_decimal_places, default: 0
    attribute :numbers
    attribute :result
    attribute :random

    def initialize(attributes = {})
      super

      if ranges.is_a?(Array)
        if ranges.length != 2
          raise "when ranges is an array it's length must be 2"
        end
      else
        self.ranges = [ranges, ranges]
      end

      initialize_numbers if result.blank?
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
        generate_division_numbers(*ranges, result_range)
      when "multiplication"
        generate_multiplication_numbers(*ranges, result_range)
      when "subtraction"
        generate_subtraction_numbers(*ranges, result_range)
      when "addition" # , "multiplication"
        ranges.map { |r| random.rand(r) }
      else
        raise ArgumentError, "Unknown equation type: #{type}"
      end
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
