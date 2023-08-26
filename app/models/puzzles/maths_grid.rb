# frozen_string_literal: true

# == Schema Information
#
# Table name: puzzles
#
#  id         :bigint           not null, primary key
#  config     :jsonb
#  level      :integer
#  reward     :text
#  seed       :bigint
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Puzzles
  class MathsGrid < ::Puzzle
    # include ActiveModel::API
    # include ActiveModel::Attributes
    include RandomInRange

    after_initialize :set_defaults

    jsonb_accessor :config,
                   rows: [:integer, default: 4],
                   columns: [:integer, default: 6]

    #                enable_addition: [:boolean, default: true],
    #                addition_numbers_count: [:integer, default: 0],
    #                addition_numbers_range: [:integer, default: 0],

    #                enable_subtraction: [:boolean, default: false],
    #                subtraction_numbers_count: [:integer, default: 0],
    #                subtraction_numbers_range: [:integer, default: 0],

    #                enable_multiplication: [:boolean, default: false],
    #                multiplication_numbers_count: [:integer, default: 0],
    #                multiplication_numbers_range: [:integer, default: 0],

    #                enable_division: [:boolean, default: false],
    #                dividends_range: [:integer, default: 0],
    #                divisors_range: [:integer, default: 0]

    enum :level, %w[6-8], prefix: "level"

    def levels_configs
      {
        "6-8" => {
          addition: {
            count: 2..4,
            range: 1..9,
            result_range: 2..10,
          },
          subtraction: {
            count: 2..4,
            range: 1..9,
            # negative_results: false,
          },
          multiplication: {
            count: 2..2,
          },
          division: {
            count: 2..2,
          }
        }
      }.with_indifferent_access
    end

    def level_config
      levels_configs[level]
    end

    # def self.addition_numbers_options
    #   []
    # end

    # def initialize(attributes = {})
    #   super

    #   @random = Random.new
    # end

    def cells
      @cells ||= rows.times.map do |_row|
        columns.times.map do |_col|
          case random_cell_type
          when :addition then Equations::Addition.new(**level_config[:addition].merge(random:))
          when :subtraction then Equations::Subtraction.new(*level_config[:subtraction])
          when :multiplication then Equations::Multiplication.new(**level_config[:multiplication])
          when :division then Equations::Division.new(**level_config[:division])
          end
        end
      end
    end

  private

    # def addition_equation_params
    #   params = { random: @random }
    #   params.merge!(ADDITION_NUMBER_COUNT_OPTIONS[addition_numbers_count])
    #   params.merge!(ADDITION_NUMBER_RANGE_OPTIONS[addition_numbers_range])
    #   params.merge(
    #     result_min: 0,
    #     result_max: 5000,
    #   )
    # end

    # def subtraction_equation_params
    #   params = { random: @random }
    #   params.merge!(SUBTRACTION_NUMBER_COUNT_OPTIONS[subtraction_numbers_count])
    #   params.merge!(SUBTRACTION_NUMBER_RANGE_OPTIONS[subtraction_numbers_range])
    #   params.merge(
    #     result_min: 0,
    #     result_max: nil,
    #   )
    # end

    # def multiplication_equation_params
    #   params = { random: @random }
    #   params.merge!(MULTIPLICATION_NUMBER_COUNT_OPTIONS[multiplication_numbers_count])
    #   params.merge!(MULTIPLICATION_NUMBER_RANGE_OPTIONS[multiplication_numbers_range])
    #   params.merge(
    #     result_min: 0,
    #     result_max: nil,
    #   )
    # end

    # def division_equation_params
    #   params = { random: @random }
    #   params.merge!(DIVIDENDS_RANGE_OPTIONS[dividends_range])
    #   params.merge!(DIVISORS_RANGE_OPTIONS[divisors_range])
    #   params.merge(
    #     result_min: 0,
    #     result_max: nil,
    #   )
    # end

    # def dividends_from_not_greater_than_to
    #   errors.add(:dividends_from, "cannot be greater than dividends_to") if dividends_from > dividends_to
    # end

    # def divisors_from_not_greater_than_to
    #   errors.add(:divisors_from, "cannot be greater than divisors_to") if divisors_from > divisors_to
    # end

    # def factors_from_not_greater_than_to
    #   errors.add(:factors_from, "cannot be greater than factors_to") if factors_from > factors_to
    # end

    # def factors_count_min_not_greater_than_max
    #   errors.add(:factors_count_min, "cannot be greater than factors_to") if factors_count_min > factors_count_max
    # end

    def random
      @random ||= Random.new(seed)
    end

    def random_cell_type
      cell_types = levels_configs.keys
      cell_types.sample(random:)
      :addition
    end

    def set_defaults
      self.seed ||= rand(2**32)
    end
  end
end
