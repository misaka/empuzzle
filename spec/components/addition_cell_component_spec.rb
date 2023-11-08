require "rails_helper"

RSpec.describe AdditionCellComponent, type: :component do
  let(:equation) do
    Puzzles::MathsGrid::Equation.from_h(
      "numbers" => [8, 7],
      "result" => 15,
      "type" => "addition"
    )
  end

  before do
    render_inline(
      described_class.new(
        equation:,
        maths_grid: build(:maths_grid, seed: 31_337)
      )
    )
  end

  it "renders the component" do
    expect(page).to have_text(/8 \+ 7\s+=\s+15/)
  end

  it "does not print the result" do
    expect(page).to have_css('span.print\\:hidden', text: "15")
  end
end
