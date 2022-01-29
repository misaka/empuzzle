class Puzzles::MathsGridController < ApplicationController
  def show
    rows = params.fetch(:rows, 10).to_i
    cols = params.fetch(:columns, 10).to_i

    @table_rows = MathsGridKizzle.new(cols: cols, rows: rows).cells
  end

  private

end
