#!/usr/bin/env ruby
# frozen_string_literal: true

module Puzzles
  class MathsGridPageObject < BasePageObject
    set_url "/puzzles/maths-grid"

    element :rows_field, "input#puzzles_maths_grid_rows"
    element :columns_field, "input#puzzles_maths_grid_columns"

    class Row < SitePrism::Section
      elements :cells, ".kids-puzzles-maths-grid-cell"
    end

    sections :rows, Row, ".kids-puzzles-maths-grid-row"
  end
end
