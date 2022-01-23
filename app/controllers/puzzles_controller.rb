class PuzzlesController < ApplicationController
  def maths_grid
    seed = params.fetch(:seed, Random.new_seed)
    random = Random.new(seed)
    rows = params.fetch(:rows, 10)
    cols = params.fetch(:cols, 10)
    config = OpenStruct.new(
      dividend_max: params.fetch(:dividend_max, 1000),
      divisor_max: params.fetch(:dividend_max, 20)
    )

    @table_rows = Array.new(rows) { Array.new(cols) }
    rows.times do |row|
      cols.times do |col|
        @table_rows[row][col] = generate_division_cell(random, config)
      end
    end
    console

    nil
  end

  private

  def generate_division_cell(random, config)
    dividend = random.rand(config.dividend_max).round
    divisor = random.rand(config.divisor_max - 2).round + 2
    OpenStruct.new(
      type: 'division',
      dividend: dividend,
      divisor: divisor
    )
  end
end
