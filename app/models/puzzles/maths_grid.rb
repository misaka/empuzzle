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

    enum :level, ["ages 6-7 (KS1)", "ages 7-8 (KS2)"], prefix: "level"

    def levels_configs
      @levels_configs ||= {
        "ages 6-7 (KS1)" => {
          rows: 6,
          columns: 2,
          equations: {
            addition: {
              ranges: 1..9,
              result_range: 2..10
            },
            subtraction: {
              ranges: [2..10, 1..5],
              result_range: 1..9
            },
            multiplication: {
              ranges: 1..9
            },
            division: {
              ranges: [2..20, 2..5],
              result_decimal_places: 0
            }
          }
        },
        "ages 7-8 (KS2)" => {
          rows: 6,
          columns: 2,
          equations: {
            addition: {
              ranges: 1..9,
              result_range: 2..10
            },
            subtraction: {
              ranges: 1..9,
              result_range: 1..9
              # negative_results: false,
            },
            multiplication: {
              ranges: 1..9
            },
            division: {
              ranges: [2..20, 2..5],
              result_decimal_places: 0
            }
          }
        }
      }.with_indifferent_access
    end

    def level_config
      levels_configs[level]
    end

    def cells
      @cells ||=
        data["cells"].map { |row| row.map { |cell| Equation.from_h(cell) } }
    end

    def type_name
      I18n.t("puzzles.maths_grid.type_name")
    end

    def to_s
      I18n.t(
        "puzzles.maths_grid.to_s",
        level: I18n.t("puzzles.maths_grid.levels.#{level}"),
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
      self.level ||= "ages 6-7 (KS1)"
      self.seed ||= rand(2**32)
    end

    def generate_cells
      equations = Set.new

      rows.times.map do |_row|
        columns.times.map do |_col|
          eq = nil
          loop do
            cell_type = random_cell_type
            eq =
              Equation.new(
                **level_config[:equations][cell_type].merge(
                  random:,
                  type: cell_type
                )
              )
            break unless equations.include?(eq.to_h)
          ensure
            equations.add(eq.to_h)
          end
          eq
        end
      end
    end
  end
end
