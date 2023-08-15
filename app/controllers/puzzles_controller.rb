# frozen_string_literal: true

class PuzzlesController < ApplicationController
  def index; end

  def maths_gridzilla
    @puzzle = Puzzles::MathsGridzilla.new(maths_gridzilla_create_params[:puzzles_maths_gridzilla])
    @puzzle.validate!
    @reward = params[:reward] || ""
  end

  def maths_grid
    @puzzle = Puzzles::MathsGrid.new(maths_grid_create_params[:puzzles_maths_grid])
    @puzzle.validate!
    @reward = params[:reward] || ""
  end

  def number_line_maths
    @puzzle = Puzzles::NumberLineMaths.new(number_line_maths_create_params[:puzzles_number_line_maths])
    @puzzle.validate!
    @reward = params[:reward] || ""
  end

private

  def maths_gridzilla_create_params
    params
      .permit(
        puzzles_maths_gridzilla: %i[
          rows
          columns
          factors_from
          factors_to
          factors_count_min
          factors_count_max
          dividends_from
          dividends_to
          divisors_from
          divisors_to
          addition_count_min
          addition_count_max
          addition_from
          addition_to
          subtraction_count_min
          subtraction_count_max
          subtraction_from
          subtraction_to
        ],
      )
  end

  def maths_grid_create_params
    params
      .permit(
        puzzles_maths_grid: %i[
          rows
          columns
          enable_addition
          addition_numbers_count
          addition_numbers_range
          enable_subtraction
          subtraction_numbers_count
          subtraction_numbers_range
          enable_multiplication
          enable_division
        ],
      )
  end

  def number_line_maths_create_params
    params
      .permit(
        puzzles_number_line_maths: %i[
          rows
          reward
          line_range_from
          line_range_to
          addition_numbers_count_min
          addition_numbers_count_max
          addition_numbers_from
          addition_numbers_to
        ],
      )
  end
end
