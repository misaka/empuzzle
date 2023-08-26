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

private

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
            level
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
