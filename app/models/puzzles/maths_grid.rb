# frozen_string_literal: true

# == Schema Information
#
# Table name: puzzles
#
#  id         :bigint           not null, primary key
#  config     :jsonb
#  data       :jsonb
#  level      :integer
#  reward     :text
#  seed       :bigint
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Puzzles
  class MathsGrid < ::Puzzle
    before_create :generate_data
    after_initialize :set_defaults

    jsonb_accessor :config, rows: [:integer], columns: [:integer]

    enum :level, %w[ages_6_to_7 ages_7_to_8], prefix: "level"

    def levels_configs
      @levels_configs ||= {
        "ages_6_to_7" => {
          rows: 6,
          columns: 2,
          equations: {
            addition: {
              augend_range: 1..9,
              sum_range: 2..10
            },
            subtraction: {
              minuend_range: 2..10,
              subtrahend_range: 1..5,
              difference_range: 1..9
            },
            multiplication: {
              multiplier_range: 1..9
            },
            division: {
              dividend_range: 2..20,
              divisor_range: 2..5,
              quotient_range: 1..9
            }
          }
        },
        "ages_7_to_8" => {
          rows: 6,
          columns: 2,
          equations: {
            addition: {
              augend_range: 1..9,
              sum_range: 2..10
            },
            subtraction: {
              minuend_range: 2..10,
              subtrahend_range: 1..5,
              difference_range: 1..9
            },
            multiplication: {
              multiplier_range: 1..9
            },
            division: {
              dividend_range: 2..20,
              divisor_range: 2..5,
              quotient_range: 1..9
            }
          }
        }
      }
    end

    def level_config
      levels_configs[level]
    end

    def cells
      @cells ||=
        data["cells"].map { |row| row.map { |cell| ::Equation.from_h(cell) } }
    end

    def to_s
      I18n.t(
        "puzzles.maths_grid.to_s",
        level: self.class.human_attribute_name(level),
        size: "#{columns}x#{rows}"
      )
    end

    def columns
      level_config[:columns]
    end

    def rows
      level_config[:rows]
    end

    def generate_data
      self.data ||= { cells: generate_cells.map { |row| row.map(&:to_h) } }
    rescue StandardError => e
      Rails.logger.error("Error generating data for (seed=#{seed}) #{self}")
      raise e
    end

    private

    def random
      @random ||= Random.new(seed)
    end

    def random_cell_type
      cell_types = level_config[:equations].keys
      cell_types.sample(random:)
    end

    def set_defaults
      self.level ||= "ages_6_to_7"
      self.seed ||= rand(2**32)
    end

    def generate_cells
      equations = Set.new

      rows.times.map do |_row|
        columns.times.map do |_col|
          eq = nil
          loop do
            eq = generate_equation(random_cell_type)
            break unless equations.include?(eq.to_h)
          ensure
            equations.add(eq.to_h)
          end
          eq
        end
      end
    end

    def generate_equation(cell_type)
      config = level_config[:equations][cell_type].merge(random:)
      ::Equation.generate(type: cell_type, **config)
    end
  end
end
