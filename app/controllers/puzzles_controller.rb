class PuzzlesController < ApplicationController
  def index; end

  def maths_grid
    @puzzle = MathsGridPuzzle.new(maths_grid_create_params)
    @puzzle.validate!
    @reward = params[:reward] || ''
  end

  private

  def maths_grid_create_params
    params
      .permit(:maths_grid_puzzle)
      .permit(
        :rows, :columns,
        :factors_from, :factors_to, :factors_count_min, :factors_count_max,
        :dividends_from, :dividends_to, :divisors_from, :divisors_to,
      )
  end

  def transform_values_for_keys(p, *keys, &block)
    p.merge(p.slice(*keys).transform_values(&block))
  end
end
