# frozen_string_literal: true

class PuzzlesController < ApplicationController
  before_action :set_puzzle_type, only: %i[create new]

  def create
    @puzzle = @puzzle_class.new(puzzle_params)
    @puzzle.validate
    if @puzzle.valid?
      @puzzle.save!
      redirect_to puzzle_path(@puzzle)
    else
      render :new
    end
  end

  def index; end

  def new
    @form_component = puzzle_classes[@puzzle_type][:form_component]
    @puzzle = puzzle_classes[@puzzle_type][:puzzle_class].new
  end

  def show
    @puzzle = Puzzle.find(params[:id])
    @puzzle_type = @puzzle.type.split("::").last.underscore
    @form_component = puzzle_classes[@puzzle_type][:form_component]
    @puzzle_component = puzzle_classes[@puzzle_type][:puzzle_component]
  end

  # def maths_gridzilla
  #   @puzzle = Puzzles::MathsGridzilla.new(maths_gridzilla_create_params[:puzzles_maths_gridzilla])
  #   @puzzle.validate!
  #   @reward = params[:reward] || ""
  # end

  # def maths_grid
  #   @puzzle = Puzzles::MathsGrid.new(maths_grid_create_params[:puzzles_maths_grid])
  #   @puzzle.validate
  #   @reward = params[:reward] || ""
  # end

  # def number_line_maths
  #   @puzzle = Puzzles::NumberLineMaths.new(number_line_maths_create_params[:puzzles_number_line_maths])
  #   @puzzle.validate!
  #   @reward = params[:reward] || ""
  # end

private

  # def maths_gridzilla_create_params
  #   params
  #     .permit(
  #       puzzles_maths_gridzilla: %i[
  #         rows
  #         columns
  #         factors_from
  #         factors_to
  #         factors_count_min
  #         factors_count_max
  #         dividends_from
  #         dividends_to
  #         divisors_from
  #         divisors_to
  #         addition_count_min
  #         addition_count_max
  #         addition_from
  #         addition_to
  #         subtraction_count_min
  #         subtraction_count_max
  #         subtraction_from
  #         subtraction_to
  #       ],
  #     )
  # end

  # def number_line_maths_create_params
  #   params
  #     .permit(
  #       puzzles_number_line_maths: %i[
  #         rows
  #         reward
  #         line_range_from
  #         line_range_to
  #         addition_numbers_count_min
  #         addition_numbers_count_max
  #         addition_numbers_from
  #         addition_numbers_to
  #       ],
  #     )
  # end

  def puzzle_classes
    {
      # maths_gridzilla: {
      #   puzzle_class: Puzzles::MathsGridzilla,
      #   form_component: MathsGridzillaFormComponent,
      #   puzzle_component: MathsGridzillaComponent,
      # },
      maths_grid: {
        puzzle_class: Puzzles::MathsGrid,
        form_component: MathsGridFormComponent,
        puzzle_component: MathsGridComponent,
      },
      # number_line_maths: {
      #   puzzle_class: Puzzles::NumberLineMaths,
      #   form_component: NumberLineMathsFormComponent,
      #   puzzle_component: NumberLineMathsComponent,
      # },
    }.with_indifferent_access
  end

  def puzzle_params
    params
      .fetch(:puzzles_maths_grid, {})
      .permit(
        %i[
            rows
            columns
            enable_addition
            addition_numbers_count
            addition_numbers_range
            enable_subtraction
            subtraction_numbers_count
            subtraction_numbers_range
            enable_multiplication
            multiplication_numbers_count
            multiplication_numbers_range
            enable_division
            dividends_range
            divisors_range
            reward
          ],
      )
  end

  def set_puzzle_type
    @puzzle_type = params[:puzzle_type].underscore
    @puzzle_class = puzzle_classes[@puzzle_type][:puzzle_class]
    @form_component = puzzle_classes[@puzzle_type][:form_component]
    @puzzle_component = puzzle_classes[@puzzle_type][:puzzle_component]
  end
end
