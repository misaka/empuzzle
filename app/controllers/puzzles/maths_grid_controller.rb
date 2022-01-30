class Puzzles::MathsGridController < ApplicationController
  def show
    @rows = params.fetch(:rows, 10).to_i
    @columns = params.fetch(:columns, 10).to_i

    @cells = MathsGridKizzle.new(rows: @rows, columns: @columns).cells
  end
end
