require "rails_helper"

RSpec.describe DivisionCellComponent, type: :component do
  let(:equation) do
    Equation.from_h("numbers" => [15, 3], "result" => 5, "type" => "division")
  end

  let!(:rendered_component) do
    render_inline(described_class.new(equation:, show_answers: false))
  end

  it "renders the component" do
    expect(page).to have_text(/15 ÷ 3\s+=\s+5/)
  end

  it "does not print the result" do
    expect(page).to have_css('span.print\\:hidden', text: "5")
  end

  it "hides the answer" do
    expect(page).to have_css("span.invisible", text: "5")
  end

  context "when show_answers is true" do
    let!(:rendered_component) do
      render_inline(described_class.new(equation:, show_answers: true))
    end

    it "shows the answer" do
      expect(page).not_to have_css("span.invisible", text: "5")
    end
  end
end
