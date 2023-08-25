# frozen_string_literal: true

module Puzzles
  class MathsGrid
    include ActiveModel::API
    include ActiveModel::Attributes
    include RandomInRange

    ADDITION_NUMBER_COUNT_OPTIONS = [
      {
        count_min: 2,
        count_max: 2,
      },
      {
        count_min: 2,
        count_max: 3,
      },
      {
        count_min: 2,
        count_max: 4,
      },
      {
        count_min: 3,
        count_max: 3,
      },
      {
        count_min: 3,
        count_max: 4,
      },
      {
        count_min: 4,
        count_max: 4,
      },
    ].freeze
    ADDITION_NUMBER_RANGE_OPTIONS = [
      {
        range_start: 2,
        range_end: 9,
      },
      {
        range_start: 2,
        range_end: 20,
      },
      {
        range_start: 2,
        range_end: 50,
      },
      {
        range_start: 2,
        range_end: 100,
      },
    ].freeze

    SUBTRACTION_NUMBER_COUNT_OPTIONS = [
      {
        count_min: 2,
        count_max: 2,
      },
      {
        count_min: 2,
        count_max: 3,
      },
      {
        count_min: 2,
        count_max: 4,
      },
      {
        count_min: 3,
        count_max: 3,
      },
      {
        count_min: 3,
        count_max: 4,
      },
      {
        count_min: 4,
        count_max: 4,
      },
    ].freeze
    SUBTRACTION_NUMBER_RANGE_OPTIONS = [
      {
        range_start: 2,
        range_end: 9,
      },
      {
        range_start: 2,
        range_end: 20,
      },
      {
        range_start: 2,
        range_end: 50,
      },
      {
        range_start: 2,
        range_end: 100,
      },
    ].freeze

    MULTIPLICATION_NUMBER_COUNT_OPTIONS = [
      {
        count_min: 2,
        count_max: 2,
      },
      {
        count_min: 2,
        count_max: 3,
      },
      {
        count_min: 2,
        count_max: 4,
      },
      {
        count_min: 3,
        count_max: 3,
      },
      {
        count_min: 3,
        count_max: 4,
      },
      {
        count_min: 4,
        count_max: 4,
      },
    ].freeze
    MULTIPLICATION_NUMBER_RANGE_OPTIONS = [
      {
        range_start: 2,
        range_end: 9,
      },
      {
        range_start: 2,
        range_end: 20,
      },
      {
        range_start: 2,
        range_end: 50,
      },
      {
        range_start: 2,
        range_end: 100,
      },
    ].freeze

    DIVISORS_RANGE_OPTIONS = [
      {
        divisors_min: 2,
        divisors_max: 9,
      },
      {
        divisors_min: 3,
        divisors_max: 19,
      },
      {
        divisors_min: 3,
        divisors_max: 40,
      },
      {
        divisors_min: 10,
        divisors_max: 100,
      },
    ].freeze

    DIVIDENDS_RANGE_OPTIONS = [
      {
        dividends_min: 10,
        dividends_max: 100,
      },
      {
        dividends_min: 100,
        dividends_max: 1000,
      },
      {
        dividends_min: 100,
        dividends_max: 10_000,
      },
    ].freeze

    attribute :rows,                   :integer, default: 4
    attribute :columns,                :integer, default: 6

    attribute :enable_addition,        :boolean, default: true
    attribute :addition_numbers_count, :integer, default: 0
    attribute :addition_numbers_range, :integer, default: 0

    attribute :enable_subtraction,        :boolean, default: false
    attribute :subtraction_numbers_count, :integer, default: 0
    attribute :subtraction_numbers_range, :integer, default: 0

    attribute :enable_multiplication,        :boolean, default: false
    attribute :multiplication_numbers_count, :integer, default: 0
    attribute :multiplication_numbers_range, :integer, default: 0

    attribute :enable_division, :boolean, default: false
    attribute :dividends_range, :integer, default: 0
    attribute :divisors_range,  :integer, default: 0

    validates :rows,    presence: true, numericality: { greater_than: 0, less_than: 9 }
    validates :columns, presence: true, numericality: { greater_than: 2, less_than: 11 }

    validates :enable_addition, inclusion: { in: [true, false] }
    validates :addition_numbers_count, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 7 }
    validates :addition_numbers_range, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 4 }

    validates :enable_subtraction, inclusion: { in: [true, false] }
    validates :subtraction_numbers_count, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 7 }
    validates :subtraction_numbers_range, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 4 }

    validates :enable_multiplication, inclusion: { in: [true, false] }
    validates :multiplication_numbers_count, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 7 }
    validates :multiplication_numbers_range, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 4 }

    validates :enable_division,  inclusion: { in: [true, false] }
    validates :dividends_range,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 4 }
    validates :divisors_range,   presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 4 }

    def self.addition_numbers_options
      []
    end

    def initialize(attributes = {})
      super

      @random = Random.new
    end

    def cells
      @cells ||= rows.times.map do |_row|
        columns.times.map do |_col|
          case random_cell_type
          when :addition then Equations::Addition.new(**addition_equation_params)
          when :subtraction then Equations::Subtraction.new(**subtraction_equation_params)
          when :multiplication then Equations::Multiplication.new(**multiplication_equation_params)
          when :division then Equations::Division.new(**division_equation_params)
          end
        end
      end
    end

  private

    def addition_equation_params
      params = { random: @random }
      params.merge!(ADDITION_NUMBER_COUNT_OPTIONS[addition_numbers_count])
      params.merge!(ADDITION_NUMBER_RANGE_OPTIONS[addition_numbers_range])
      params.merge(
        result_min: 0,
        result_max: 5000,
      )
    end

    def subtraction_equation_params
      params = { random: @random }
      params.merge!(SUBTRACTION_NUMBER_COUNT_OPTIONS[subtraction_numbers_count])
      params.merge!(SUBTRACTION_NUMBER_RANGE_OPTIONS[subtraction_numbers_range])
      params.merge(
        result_min: 0,
        result_max: nil,
      )
    end

    def multiplication_equation_params
      params = { random: @random }
      params.merge!(MULTIPLICATION_NUMBER_COUNT_OPTIONS[multiplication_numbers_count])
      params.merge!(MULTIPLICATION_NUMBER_RANGE_OPTIONS[multiplication_numbers_range])
      params.merge(
        result_min: 0,
        result_max: nil,
      )
    end

    def division_equation_params
      params = { random: @random }
      params.merge!(DIVIDENDS_RANGE_OPTIONS[dividends_range])
      params.merge!(DIVISORS_RANGE_OPTIONS[divisors_range])
      params.merge(
        result_min: 0,
        result_max: nil,
      )
    end

    def dividends_from_not_greater_than_to
      errors.add(:dividends_from, "cannot be greater than dividends_to") if dividends_from > dividends_to
    end

    def divisors_from_not_greater_than_to
      errors.add(:divisors_from, "cannot be greater than divisors_to") if divisors_from > divisors_to
    end

    def factors_from_not_greater_than_to
      errors.add(:factors_from, "cannot be greater than factors_to") if factors_from > factors_to
    end

    def factors_count_min_not_greater_than_max
      errors.add(:factors_count_min, "cannot be greater than factors_to") if factors_count_min > factors_count_max
    end

    def random_cell_type
      cell_types = []
      cell_types << :addition       if enable_addition
      cell_types << :subtraction    if enable_subtraction
      cell_types << :multiplication if enable_multiplication
      cell_types << :division       if enable_division

      cell_types.sample(random: @random)
    end
  end
end
