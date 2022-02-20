#!/usr/bin/env ruby

class Puzzles::MathsGridPageObject < BasePageObject
  set_url "/puzzles/maths-grid"

  element :rows_field, 'input#puzzles_maths_grid_rows'
  element :columns_field, 'input#puzzles_maths_grid_columns'

  class MathsGridRow < SitePrism::Section
    elements :cells, ".kids-puzzles-maths-grid-cell"
  end

  sections :rows, MathsGridRow, '.kids-puzzles-maths-grid-row'
end
