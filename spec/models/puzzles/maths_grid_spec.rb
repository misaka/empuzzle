require "rails_helper"

RSpec.describe Puzzles::Maths::ArithmeticGrid do
  let(:level) { Puzzles::Maths::ArithmeticGrid.levels.first.first }
  let(:size) { "small" }

  it "does not fail to generate puzzles even with a low entropy puzzle" do
    # This is a pretty brute-force test, but it's pretty quick. The point is we
    # should be able to generate a bunch of puzzles without triggering errors
    # where equations can't be generated due to the entropy restrictions of the
    # puzzle settings (i.e. the number of available puzzle combinations is too
    # low and the puzzle generator gives up to avoid getting into an infinite
    # loop).
    #
    # Also, the following URL currently generates an error:
    #
    #   http://localhost:3000/puzzles/maths_grid/19498556
    #
    # But although just testing this could be handy, it would be too easy for
    # this seed to start passing the test suddenly, which is why we use the
    # brute force method here.
    expect {
      100.times { |_n| described_class.new(level:, size:).generate_data }
    }.not_to raise_error
  end

  it "does not repeat equations in the same puzzle" do
    10.times do
      puzzle = described_class.new(level:, size:)
      cells = puzzle.generate_data[:cells].flatten
      expect(cells.uniq).to eq cells
    end
  end

  describe "validations" do
    it { should validate_presence_of :level }
    it { should validate_presence_of :size }
  end
end
