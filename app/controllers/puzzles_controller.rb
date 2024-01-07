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

  def index
    @puzzles = Puzzle.all.order(created_at: :desc)
  end

  def new
    @form_component = puzzle_classes[@puzzle_type][:form_component]
    @puzzle = puzzle_classes[@puzzle_type][:puzzle_class].new
  end

  def show
    if params[:id]
      @puzzle = Puzzle.find(params[:id])
      @puzzle_type = @puzzle.puzzle_type
    elsif params[:puzzle_type] && params[:seed]
      @puzzle_type = params[:puzzle_type].underscore
      @puzzle =
        puzzle_classes[@puzzle_type][:puzzle_class].new(seed: params[:seed])
      @puzzle.generate_data
    end

    @show_answers = (params["show_answers"] == "yes")

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
      "maths/arithmetic_grid": {
        puzzle_class: Puzzles::Maths::ArithmeticGrid,
        form_component: MathsGridFormComponent,
        puzzle_component: MathsGridComponent
      },
      "maths/number_line_arithmetic": {
        puzzle_class: Puzzles::Maths::NumberLineArithmetic,
        form_component: NumberLineFormComponent,
        puzzle_component: NumberLinePuzzleComponent
      }
    }.with_indifferent_access
  end

  def puzzle_params
    params.fetch(@puzzle_class.name.underscore.tr("/", "_"), {}).permit(
      %i[rows columns level reward]
    )
  end

  def set_puzzle_type
    @puzzle_type = params[:puzzle_type].underscore
    @puzzle_class = puzzle_classes[@puzzle_type][:puzzle_class]
    @form_component = puzzle_classes[@puzzle_type][:form_component]
    @puzzle_component = puzzle_classes[@puzzle_type][:puzzle_component]
  end
end
