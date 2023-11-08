# frozen_string_literal: true

require "rails_helper"

RSpec.describe MathsGridComponent, type: :component do
  let(:seed) { 31_337 }
  let(:maths_grid) do
    create(
      :maths_grid,
      seed:,
      data: {
        # NB: The structure here doesn't quite match the rows and columns of
        # this maths grid, but it works (for now)
        cells: [
          [
            { type: "addition", numbers: [4, 5], result: 9 },
            { type: "subtraction", numbers: [9, 4], result: 5 },
            { type: "multiplication", numbers: [6, 2], result: 12 },
            { type: "division", numbers: [15, 5], result: 3 }
          ]
        ]
      }
    )
  end

  let(:component) { described_class.new(puzzle: maths_grid) }

  describe "the rendered component" do
    let!(:rendered) { render_inline(component) }

    subject { page }

    it { should have_css(".kids-puzzles-maths-grid") }

    describe "the rendered cells" do
      let(:cells) do
        page.find(".kids-puzzles-maths-grid").find_all(
          ".kids-puzzles-maths-grid-cell"
        )
      end

      it "should have the correct number of cells" do
        expect(cells.length).to eq 4
      end

      it "should have correctly rendered cells" do
        # Try to determine which equation compononent is rendered in each cell
        # by looking for the operator. There must be a better way ¯\_(ツ)_/¯
        expect(cells[0]).to have_text "+"
        expect(cells[1]).to have_text "-"
        expect(cells[2]).to have_text "x"
        expect(cells[3]).to have_text "÷"
      end
    end
  end
end
