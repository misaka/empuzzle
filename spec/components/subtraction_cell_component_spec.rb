require 'rails_helper'

RSpec.describe SubtractionCellComponent, type: :component do
  let(:equation) do
    Puzzles::MathsGrid::Equation.from_h(
      "numbers" => [12, 7],
      "result" => 5,
      "type" => "subtraction"
    )
  end

  it 'renders the component' do
    render_inline(
      described_class.new(
        equation: equation,
        maths_grid: build(:maths_grid, seed: 31_337)
      )
    )

    expect(page).to have_text /12 - 7\s+=\s+5/
  end
end
