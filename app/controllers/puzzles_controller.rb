class PuzzlesController < ApplicationController
  def index; end

  def maths_grid
    @puzzle = Puzzles::MathsGrid.new(maths_grid_create_params[:puzzles_maths_grid])
    @puzzle.validate!
    @reward = params[:reward] || ''
  end

  def maths_grid_2
    @puzzle = Puzzles::MathsGrid2.new(maths_grid_2_create_params[:puzzles_maths_grid])
    @puzzle.validate!
    @reward = params[:reward] || ''
  end

  def number_line_maths
    @puzzle = Puzzles::NumberLineMaths.new(number_line_maths_create_params[:puzzles_number_line_maths])
    @puzzle.validate!
    @reward = params[:reward] || ''
  end

  private

  def maths_grid_create_params
    params
      .permit(
        puzzles_maths_grid: [
          :rows, :columns,
          :factors_from, :factors_to, :factors_count_min, :factors_count_max,
          :dividends_from, :dividends_to, :divisors_from, :divisors_to,
          :addition_count_min, :addition_count_max,
          :addition_from, :addition_to,
          :subtraction_count_min, :subtraction_count_max,
          :subtraction_from, :subtraction_to,
        ]
      )
  end

  def maths_grid_2_create_params
    params
      .permit(
        puzzles_maths_grid: [
          :rows, :columns,
          :factors_from, :factors_to, :factors_count_min, :factors_count_max,
          :dividends_from, :dividends_to, :divisors_from, :divisors_to,
          :addition_count_min, :addition_count_max,
          :addition_from, :addition_to,
          :subtraction_count_min, :subtraction_count_max,
          :subtraction_from, :subtraction_to,
        ]
      )
  end

  def number_line_maths_create_params
    params
      .permit(
        puzzles_number_line_maths: [
          :rows,
          :reward,
          :line_range_from, :line_range_to,
          :addition_numbers_count_min, :addition_numbers_count_max,
          :addition_numbers_from, :addition_numbers_to
        ]
      )
  end

  def transform_values_for_keys(p, *keys, &block)
    p.merge(p.slice(*keys).transform_values(&block))
  end
end
