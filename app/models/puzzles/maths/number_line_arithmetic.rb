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
    class NumberLineArithmetic < ::Puzzle
      after_initialize :set_defaults
      after_initialize :generate_puzzle

      jsonb_accessor :config,
                     rows: [:integer],
                     line_range_from: [:integer],
                     line_range_to: [:integer]

      enum :level,
           %w[ages_6_to_7 ages_7_to_8],
           default: "ages_6_to_7",
           prefix: "level"

      def sizes
        HashWithIndifferentAccess.new(
          { small: { rows: 6 }, medium: { rows: 8 }, large: { rows: 8 } }
        )
      end

      def levels_configs
        @levels_configs ||= {
          "ages_6_to_7" => {
            line_range: 0..10,
            equations: {
              addition: {
                augend_range: 1..9,
                sum_range: 2..10
              }
              # subtraction: {
              #   minuend_range: 2..10,
              #   subtrahend_range: 1..5,
              #   difference_range: 1..9
              # },
            }
          },
          "ages_7_to_8" => {
            line_range: 0..10,
            equations: {
              addition: {
                augend_range: 1..9,
                sum_range: 2..10
              }
              # subtraction: {
              #   minuend_range: 2..10,
              #   subtrahend_range: 1..5,
              #   difference_range: 1..9
              # },
            }
          }
        }
      end

      def line_range
        @line_range ||= line_range_from..line_range_to
      end

      def line_length
        @line_length ||= line_range.size - 1
      end

      def cells
        @cells ||= data["cells"].map { |cell| ::Equation.from_h(cell) }
      end

      def to_s
        I18n.t(
          "puzzles.maths.number_line_arithmetic.to_s",
          level: self.class.human_attribute_name(level)
        )
      end

      private

      def level_config
        levels_configs[level]
      end

      def set_defaults
        self.rows ||= level_config[:rows]
        self.line_range_from ||= level_config[:line_range].begin
        self.line_range_to ||= level_config[:line_range].end

        self.seed ||= rand(2**32)
      end

      def random
        @random ||= Random.new(seed)
      end

      def generate_puzzle
        self.data ||= {
          cells: generate_cells(level_config[:equations]).map(&:to_h)
        }
      rescue StandardError => e
        Rails.logger.error("Error generating data for (seed=#{seed}) #{self}")
        raise e
      end

      def random_cell_type
        %i[addition].sample(random: @random)
      end

      def generate_cells(equations_config)
        equations = Set.new

        sizes[size][:rows].times.map do |_row|
          eq = nil
          loop do
            equation_type = random_cell_type
            eq =
              generate_equation(equation_type, equations_config[equation_type])
            break unless equations.include?(eq.to_h)
          ensure
            equations.add(eq.to_h)
          end
          eq
        end
      end

      def generate_equation(type, equation_config)
        ::Equation.generate(type:, random:, **equation_config)
      end
    end
  end
end
