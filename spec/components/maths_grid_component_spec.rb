# frozen_string_literal: true

require "rails_helper"

RSpec.describe MathsGridComponent, type: :component do
  let(:seed) { 31_337 }
  let(:maths_grid) { create(:maths_grid, seed:, rows: 8, columns: 3) }

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
        expect(cells.length).to eq 24
      end

      it "should have correctly rendered cells" do
        # The cell values are determined by the seed. If the way the seed is
        # used to generate the random number, he cells will change and test will
        # break.
        #
        # This test overlaps with the equation components, but this test needs to
        # check that the correct cell type is rendered.
        expect(cells[0].text).to include("2\n⟌16")
        expect(cells[2].text).to include("6 x 9")
        expect(cells[3].text).to include("1 + 3")
        expect(cells[6].text).to include("9 - 8")
      end
    end
  end
end
