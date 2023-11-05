require 'rails_helper'

RSpec.describe MultiplicationCellComponent, type: :component do
  let(:equation) do
    Puzzles::MathsGrid::Equation.from_h(
      "numbers" => [2, 7],
      "result" => 14,
      "type" => "multiplication"
    )
  end

  it 'renders the component' do
    render_inline(
      described_class.new(
        equation: equation,
        maths_grid: build(:maths_grid, seed: 31_337)
      )
    )

    expect(page).to have_text /2 x 7\s+=\s+14/
  end
end
