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

    jsonb_accessor :config,
                   rows: [:integer, { default: 4 }],
                   columns: [:integer, { default: 6 }]

    enum :level, ["ages 6-8"], prefix: "level"

    def levels_configs
      @levels_configs ||= {
        "ages 6-8" => {
          addition: {
            count: 2..2,
            range: 1..9,
            result_range: 2..10,
          },
          subtraction: {
            count: 2..2,
            range: 1..9,
            result_range: 1..9,
            # negative_results: false,
          },
          multiplication: {
            count: 2..2,
            range: 1..9,
          },
          division: {
            dividends_range: 1..20,
            divisors_range: 2..5,
            result_decimal_places: 0,
          },
        },
      }.with_indifferent_access
    end

    def level_config
      levels_configs[level]
    end

    def cells
      @cells ||= self.data["cells"].map do |row|
        row.map do |cell|
          case cell["type"]
          when "addition" then Equations::Addition.from_h(cell)
          when "subtraction" then Equations::Subtraction.from_h(cell)
          when "multiplication" then Equations::Multiplication.from_h(cell)
          when "division" then Equations::Division.from_h(cell)
          end
        end
      end
    end

    def type_name
      t("puzzles.maths_grid.type_name")
    end

    def to_s
      I18n.t(
        "puzzles.maths_grid.to_s",
        level: I18n.t("puzzles.maths_grid.levels.#{level}"),
        size: "#{columns}x#{rows}"
       )
    end

  private

    def random
      @random ||= Random.new(seed)
    end

    def random_cell_type
      cell_types = level_config.keys
      cell_types.sample(random:)
    end

    def set_defaults
      self.seed ||= rand(2**32)
    end

    def generate_data
      self.data ||= {
        cells: generate_cells.map do |row|
          row.map &:to_h
        end,
      }
    end

    def generate_cells
      rows.times.map do |_row|
        columns.times.map do |_col|
          case random_cell_type
          when "addition"
            Equations::Addition.new(
              **level_config[:addition].merge(random:),
            )
          when "subtraction"
            Equations::Subtraction.new(
              **level_config[:subtraction].merge(random:),
            )
          when "multiplication"
            Equations::Multiplication.new(
              **level_config[:multiplication].merge(random:),
            )
          when "division"
            Equations::Division.new(
              **level_config[:division].merge(random:),
            )
          end
        end
      end
    end
  end
end
