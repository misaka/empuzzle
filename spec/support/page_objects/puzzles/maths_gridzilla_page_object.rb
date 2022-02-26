#!/usr/bin/env ruby

class Puzzles::MathsGridzillaPageObject < BasePageObject
  set_url "/puzzles/maths-gridzilla"

  element :rows_field, 'input#puzzles_maths_gridzilla_rows'
  element :columns_field, 'input#puzzles_maths_gridzilla_columns'

  class Row < SitePrism::Section
    elements :cells, ".kids-puzzles-maths-grid-cell"
  end

  sections :rows, Row, '.kids-puzzles-maths-grid-row'
end
