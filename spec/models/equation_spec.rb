require "rails_helper"

RSpec.describe Equation do
  let(:random) { Random.new(31_337) }
  let(:result_decimal_places) { nil }
  let(:result_range) { nil }
  let(:ranges) { 1..9 }
  let(:type) { "addition" }

  let(:equation) { described_class.generate(**config.merge(random:)) }

  context "addition" do
    let(:config) { { type: :addition, augend_range: 1..9, addend_range: 1..9 } }

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
    let(:config) do
      {
        type: :subtraction,
        minuend_range: 1..9,
        subtrahend_range: 1..9,
        difference_range: 1..9
      }
    end

    describe "numbers" do
      subject(:numbers) { equation.numbers }

      it { should eq([8, 1]) }
    end

    describe "result" do
      subject(:result) { equation.result }

      it { should eq(7) }
    end
  end

  context "multiplication" do
    let(:config) { { type: :multiplication, multiplier_range: 1..9 } }

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
    let(:config) do
      {
        type: :division,
        dividend_range: 2..20,
        divisor_range: 2..5,
        quotient_range: 2..10
      }
    end

    describe "numbers" do
      subject(:numbers) { equation.numbers }

      it { should eq([20, 5]) }
    end

    describe "result" do
      subject(:result) { equation.result }

      it { should eq(4.0) }
    end
  end

  context "unknown equation type" do
    let(:config) { { type: :nuthin } }

    it "raises an error" do
      expect { equation }.to raise_error(
        ArgumentError,
        /unknown equation type: nuthin/i
      )
    end
  end

  describe "#to_h" do
    let(:config) { { type: :addition, augend_range: 1..9, addend_range: 1..9 } }

    subject(:hash) { equation.to_h }

    it { should eq({ numbers: [8, 7], result: 15, type: :addition }) }
  end

  describe ".from_h" do
    subject(:equation) do
      described_class.from_h({ numbers: [8, 7], result: 15, type: :addition })
    end

    it { should be_a(described_class) }
    it { should have_attributes(numbers: [8, 7], result: 15, type: :addition) }
  end
end
