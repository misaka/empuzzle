require "rails_helper"

RSpec.describe Puzzles::MathsGrid::Equation do
  let(:random) { Random.new(31_337) }
  let(:result_decimal_places) { nil }
  let(:result_range) { nil }
  let(:type) { "addition" }

  let(:equation) do
    described_class.new(
      **{
        random:,
        range: 1..9,
        result_decimal_places:,
        result_range:,
        type:
      }.compact # Remove keys with nil values
    )
  end

  context "addition" do
    describe "numbers" do
      subject(:numbers) { equation.numbers }

      it { should eq([8, 7]) }
    end

    describe "result" do
      subject(:result) { equation.result }

      it { should eq(15) }
    end
  end

  context "subtraction" do
    let(:type) { "subtraction" }
    let(:result_range) { 1..9 }

    describe "numbers" do
      subject(:numbers) { equation.numbers }

      it { should eq([8, 7]) }
    end

    describe "result" do
      subject(:result) { equation.result }

      it { should eq(1) }
    end
  end

  context "multiplication" do
    let(:type) { "multiplication" }

    describe "numbers" do
      subject(:numbers) { equation.numbers }

      it { should eq([8, 7]) }
    end

    describe "result" do
      subject(:result) { equation.result }

      it { should eq(56) }
    end
  end

  context "division" do
    let(:type) { "division" }
    let(:result_decimal_places) { 0 }
    let(:result_range) { 2.0..10.0 }
    let(:random) { Random.new(31_334) }

    describe "numbers" do
      subject(:numbers) { equation.numbers }

      it { should eq([6, 2]) }
    end

    describe "result" do
      subject(:result) { equation.result }

      it { should eq(3) }
    end
  end

  context "unknown equation type" do
    let(:type) { "nuthin" }

    it "raises an error" do
      expect { equation }.to raise_error(
        ArgumentError,
        /unknown equation type: nuthin/i
      )
    end
  end

  describe "#to_h" do
    subject(:hash) { equation.to_h }

    it { should eq({ numbers: [8, 7], result: 15, type: :addition }) }
  end

  describe ".from_h" do
    subject(:equation) do
      described_class.from_h(
        { "numbers" => [8, 7], "result" => 15, "type" => :addition }
      )
    end

    it { should be_a(described_class) }
    it { should have_attributes(numbers: [8, 7], result: 15, type: :addition) }
  end
end
