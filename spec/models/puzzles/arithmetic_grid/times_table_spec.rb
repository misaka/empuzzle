require "rails_helper"

RSpec.describe Puzzles::Maths::ArithmeticGrid::TimesTable do
  let(:seed) { 31_337 }
  let(:level) { described_class.levels.first.first }
  let(:size) { "small" }

  describe "validations" do
    subject { described_class.new(level:, size:) }

    it { should validate_presence_of :level }
    it { should validate_presence_of :size }
  end

  describe "ages 6 to 7, medium puzzle" do
    let(:size) { "medium" }
    let(:level) { "ages_6_to_7" }

    it "generates a puzzle with 2 columns" do
      puzzle = described_class.new(level:, size:)
      expect(puzzle.generate_puzzle[:cells].first.size).to eq 2
    end

    it "generates a puzzle with the correct number of rows" do
      puzzle = described_class.new(level:, size:)
      expect(puzzle.generate_puzzle[:cells].size).to eq 8
    end

    it "generates a puzzle with the correct equations" do
      puzzle = described_class.new(level:, size:, seed:)
      expect(puzzle.generate_puzzle[:cells].flatten).to(
        eq(
          [
            { numbers: [1, 2], result: 2, type: :multiplication },
            { numbers: [1, 3], result: 3, type: :multiplication },
            { numbers: [2, 2], result: 4, type: :multiplication },
            { numbers: [2, 3], result: 6, type: :multiplication },
            { numbers: [3, 2], result: 6, type: :multiplication },
            { numbers: [3, 3], result: 9, type: :multiplication },
            { numbers: [4, 2], result: 8, type: :multiplication },
            { numbers: [4, 3], result: 12, type: :multiplication },
            { numbers: [5, 2], result: 10, type: :multiplication },
            { numbers: [5, 3], result: 15, type: :multiplication },
            { numbers: [6, 2], result: 12, type: :multiplication },
            { numbers: [6, 3], result: 18, type: :multiplication },
            { numbers: [7, 2], result: 14, type: :multiplication },
            { numbers: [7, 3], result: 21, type: :multiplication },
            { numbers: [8, 2], result: 16, type: :multiplication },
            { numbers: [8, 3], result: 24, type: :multiplication }
          ]
        )
      )
    end
  end
end
