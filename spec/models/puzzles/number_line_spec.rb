require "rails_helper"

RSpec.describe Puzzles::Maths::NumberLineArithmetic do
  let(:level) { Puzzles::Maths::ArithmeticGrid.levels.first.first }
  let(:size) { "small" }

  subject(:puzzle) { described_class.new(level:, size:) }

  it "generates a puzzle" do
    expect(subject).to be_a Puzzles::Maths::NumberLineArithmetic
  end

  describe "validations" do
    it { should validate_presence_of :level }
    it { should validate_presence_of :size }
  end

  context "saved puzzle" do
    before { puzzle.save! }

    it "generates the puzzle data" do
      expect(subject.data["cells"].length).to be 6
    end

    it "generates equations with keys numbers, result and type" do
      expect(subject.data["cells"].first).to(
        include(
          "numbers" => [a_kind_of(Integer), a_kind_of(Integer)],
          "result" => a_kind_of(Integer),
          "type" => a_kind_of(String)
        )
      )
    end
  end
end
