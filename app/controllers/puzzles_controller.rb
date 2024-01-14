# frozen_string_literal: true

class PuzzlesController < ApplicationController
  before_action :set_puzzle_type, only: %i[create new]
  before_action :set_puzzle_and_type, only: %i[show]

  def create
    @puzzle = @puzzle_class.new(puzzle_params.merge(session_id: @session_id))
    @puzzle.validate
    if @puzzle.valid?
      @puzzle.save!
      redirect_to puzzle_path(@puzzle, new_puzzle: "true")
    else
      render :new
    end
  end

  def index
    @puzzles = Puzzle.where(session_id: @session_id).order(created_at: :desc)
  end

  def new
    @form_component = puzzle_classes[@puzzle_type][:form_component]
    @puzzle = puzzle_classes[@puzzle_type][:puzzle_class].new(puzzle_params)
  end

  def show
    @show_answers = (params["show_answers"] == "true")
    @new_puzzle = (params["new_puzzle"] == "true")

    @form_component = puzzle_classes[@puzzle_type][:form_component]
    @puzzle_component = puzzle_classes[@puzzle_type][:puzzle_component]
  end

  private

  def puzzle_classes
    {
      "maths/arithmetic_grid": {
        puzzle_class: Puzzles::Maths::ArithmeticGrid,
        puzzle_component: MathsGridComponent
      },
      "maths/number_line_arithmetic": {
        puzzle_class: Puzzles::Maths::NumberLineArithmetic,
        puzzle_component: NumberLinePuzzleComponent
      }
    }.with_indifferent_access
  end

  def puzzle_params
    params.fetch(@puzzle_class.name.underscore.tr("/", "_"), {}).permit(
      %i[size level reward]
    )
  end

  def set_puzzle_type
    @puzzle_type = params[:puzzle_type].underscore
    @puzzle_class = puzzle_classes[@puzzle_type][:puzzle_class]
    @form_component = puzzle_classes[@puzzle_type][:form_component]
    @puzzle_component = puzzle_classes[@puzzle_type][:puzzle_component]
  end

  def set_puzzle_and_type
    if params[:id]
      @puzzle = Puzzle.where(session_id: @session_id).find(params[:id])
      raise ActiveRecord::RecordNotFound unless @puzzle

      @puzzle_type = @puzzle.puzzle_type
    elsif params[:puzzle_type] && params[:seed]
      @puzzle_type = params[:puzzle_type].underscore
      @puzzle =
        puzzle_classes[@puzzle_type][:puzzle_class].new(seed: params[:seed])
      @puzzle.generate_data
    end
  end
end
