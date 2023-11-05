require 'rails_helper'

RSpec.describe DivisionCellComponent, type: :component do
  let(:equation) do
    Puzzles::MathsGrid::Equation.from_h(
      "numbers" => [15, 3],
      "result" => 5,
      "type" => "division"
    )
  end

  before do
      render_inline(
      described_class.new(
        equation: equation,
        maths_grid: build(:maths_grid, seed: 31_337)
      )
    )
  end

  it "renders the component" do
    expect(page).to have_text /15 ÷ 3\s+=\s+5/
  end

  it "does not print the result" do
    expect(page).to have_css('span.print\\:hidden', text: "5")
  end
end