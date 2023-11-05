require 'rails_helper'

RSpec.describe DivisionCellComponent, type: :component do
  let(:equation) do
    Puzzles::MathsGrid::Equation.from_h(
      "numbers" => [15, 3],
      "result" => 5,
      "type" => "division"
    )
  end

  it 'renders the component' do
    render_inline(
      described_class.new(
        equation: equation,
        maths_grid: build(:maths_grid, seed: 31_337)
      )
    )

    expect(page).to have_text /15 ÷ 3\s+=\s+5/
  end
end
