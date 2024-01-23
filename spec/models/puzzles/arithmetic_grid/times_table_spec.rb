require "rails_helper"

RSpec.describe Puzzles::Maths::ArithmeticGrid::TimesTable do
  let(:seed) { 31337 }
  let(:level) { described_class.levels.first.first }
  let(:size) { "small" }

  describe "validations" do
    subject { described_class.new(level:, size:) }

    it { should validate_presence_of :level }
    it { should validate_presence_of :size }
  end

  let(:level) { described_class.levels.first.first }

  it "generates a puzzle with 1 column" do
    puzzle = described_class.new(level:, size:)
    expect(puzzle.generate_puzzle[:cells].first.size).to eq 1
  end

  it "generates a puzzle with the correct number of rows" do
    puzzle = described_class.new(level:, size:)
    expect(puzzle.generate_puzzle[:cells].size).to eq 6
  end

  it "generates a puzzle with the correct equations" do
    puzzle = described_class.new(level:, size:, seed:)
    expect(puzzle.generate_puzzle[:cells].flatten).to(
      eq(
        [
          { numbers: [1, 4], result: 4, type: :multiplication },
          { numbers: [2, 4], result: 8, type: :multiplication },
          { numbers: [3, 4], result: 12, type: :multiplication },
          { numbers: [4, 4], result: 16, type: :multiplication },
          { numbers: [5, 4], result: 20, type: :multiplication },
          { numbers: [6, 4], result: 24, type: :multiplication }
        ]
      )
    )
  end
end
