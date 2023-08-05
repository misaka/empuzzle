# frozen_string_literal: true

module Puzzles
  class NumberLineMaths
    include ActiveModel::API
    include ActiveModel::Attributes
    include RandomInRange

    attribute :rows,                       :integer, default: 6
    attribute :reward,                     :string
    attribute :line_range_from,            :integer, default: 0
    attribute :line_range_to,              :integer, default: 20
    attribute :addition_numbers_count_min, :integer, default: 2
    attribute :addition_numbers_count_max, :integer, default: 2
    attribute :addition_numbers_from,      :integer, default: 1
    attribute :addition_numbers_to,        :integer, default: 10

    def initialize(attributes = {})
      super

      @random = Random.new
    end

    def equations
      @equations ||= rows.times.map do |_row|
        case random_equation_type
        when :addition then Equations::Addition.new(**addition_equation_params)
        end
      end
    end

    def line_range
      line_range_to - line_range_from
    end

    private

    def random_equation_type
      %i[
        addition
      ].sample(random: @random)
    end

    def addition_equation_params
      {
        count_min: addition_numbers_count_min,
        count_max: addition_numbers_count_max,
        from: addition_numbers_from,
        to: addition_numbers_to,
        result_min: line_range_from,
        result_max: line_range_to,
        random: @random
      }
    end
  end
end
