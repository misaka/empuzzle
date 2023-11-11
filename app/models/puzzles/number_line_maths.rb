# frozen_string_literal: true

module Puzzles
  class NumberLineMaths < ::Puzzle
    after_initialize :set_defaults
    after_initialize :generate_puzzle

    jsonb_accessor :config, rows: [:integer]

    enum :level,
         %w[ages_6_to_7 ages_7_to_8],
         default: "ages_6_to_7",
         prefix: "level"

    def levels_configs
      @levels_configs ||= {
        "ages_6_to_7" => {
          rows: 6,
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
          rows: 6,
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
      line_range_to - line_range_from
    end

    private

    def level_config
      levels_configs[level]
    end

    def set_defaults
      self.rows ||= level_config[:rows]

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

      rows.times.map do |_row|
        eq = nil
        loop do
          equation_type = random_cell_type
          eq = generate_equation(equation_type, equations_config[equation_type])
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
