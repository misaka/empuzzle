# frozen_string_literal: true

require "rails_helper"

RSpec.describe MathsArithmeticGridComponent, type: :component do
  let(:seed) { 31_337 }
  let(:reward) { nil }
  let(:maths_grid) do
    create(
      :arithmetic_grid,
      seed:,
      reward:,
      size: "medium",
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

  it "defaults show_answers to false" do
    expect(component.show_answers).to eq false
  end

  context "setting show_answers to true" do
    let(:component) do
      described_class.new(puzzle: maths_grid, show_answers: true)
    end

    it "sets show_answers to true" do
      expect(component.show_answers).to eq true
    end
  end

  describe "rendering the component" do
    subject { page }
    let!(:rendered) { render_inline(component) }

    it { should have_css(".kids-puzzles-maths-grid") }
  end

  describe "the rendered cells" do
    subject { page }
    let!(:rendered) { render_inline(component) }
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

  describe "the reward" do
    subject { page }
    let!(:rendered) { render_inline(component) }
    let(:reward) { "TV Time 🎉" }

    # check that the reward is rendered
    it { should have_css(".kids-puzzles--reward", text: "Reward: #{reward}") }
  end
end
