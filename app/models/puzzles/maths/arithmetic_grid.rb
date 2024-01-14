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
#  size       :integer          not null
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :uuid
#
module Puzzles
  module Maths
    class ArithmeticGrid < ::Puzzle
      before_create :generate_data
      after_initialize :set_defaults

      jsonb_accessor :config, rows: [:integer], columns: [:integer]

      enum :level, %w[ages_6_to_7 ages_7_to_8], prefix: "level"

      validates :level, presence: true
      validates :size, presence: true

      def sizes
        HashWithIndifferentAccess.new(
          {
            small: {
              rows: 6,
              columns: 2
            },
            medium: {
              rows: 8,
              columns: 2
            },
            large: {
              rows: 8,
              columns: 3
            }
          }
        )
      end

      def levels_configs
        @levels_configs ||= {
          "ages_6_to_7" => {
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
            equations: {
              addition: {
                augend_range: 1..99,
                sum_range: 10..100
              },
              subtraction: {
                minuend_range: 10..100,
                subtrahend_range: 1..20
              },
              multiplication: {
                multiplier_range: 1..15,
                product_range: 10..100
              },
              division: {
                divisor_range: 2..10,
                quotient_range: 2..9
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

      def dimensions_text
        I18n.t(
          "puzzles.maths.arithmetic_grid.dimensions",
          cols: sizes[size][:columns],
          rows: sizes[size][:rows]
        )
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
        self.seed ||= rand(2**32)
      end

      def generate_cells
        equations = Set.new

        sizes[size][:rows].times.map do |_row|
          sizes[size][:columns].times.map do |_col|
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
end
