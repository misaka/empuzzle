class Puzzles::MathsGridController < ApplicationController
  def show
    seed = params.fetch(:seed, Random.new_seed)
    random = Random.new(seed)
    rows = params.fetch(:rows, 10)
    cols = params.fetch(:cols, 10)
    config = maths_grid_config(random, params)

    @table_rows = Array.new(rows) { Array.new(cols) }
    rows.times do |row|
      cols.times do |col|
        @table_rows[row][col] = case random_cell_type(random, config)
                                when :division then generate_division_cell(random, config)
                                when :multiplication then generate_multiplication_cell(random, config)
                                end
      end
    end
  end

  private

  def maths_grid_config(random, params)
    OpenStruct.new(
      division: OpenStruct.new(
        dividend_max: params.fetch(:dividend_max, 1000),
        divisor_max: params.fetch(:divisor_max, 20)
      ),
      multiplication: OpenStruct.new(
        max_factors_count: params.fetch(:max_factors_count, 3),
        factor_max: params.fetch(:factor_max, 12)
      )
    )
  end

  def generate_division_cell(random, config)
    dividend = random.rand(config.division.dividend_max).round
    divisor = random.rand(config.division.divisor_max - 2).round + 2
    OpenStruct.new(
      type: 'division',
      dividend: dividend,
      divisor: divisor
    )
  end

  def generate_multiplication_cell(random, config)
    factors_count = 2 + random.rand(config.multiplication.max_factors_count - 1).round
    factors = factors_count.times.map do |n|
      2 + random.rand(config.multiplication.factor_max - 1)
    end

    OpenStruct.new(
      type: 'multiplication',
      factors: factors,
      results_length: factors.inject(:*).to_s.length
    )
  end

  def random_cell_type(random, config)
    types = [:division, :multiplication]

    types[random.rand(types.length).round]
  end
end
