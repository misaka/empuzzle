require "rails_helper"

RSpec.describe MultiplicationCellComponent, type: :component do
  let(:equation) do
    Equation.from_h(
      "numbers" => [2, 7],
      "result" => 14,
      "type" => "multiplication"
    )
  end

  before { render_inline(described_class.new(equation:)) }

  it "renders the component" do
    expect(page).to have_text(/2 x 7\s+=\s+14/)
  end

  it "does not print the result" do
    expect(page).to have_css('span.print\\:hidden', text: "14")
  end
end
