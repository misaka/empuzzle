require "rails_helper"

RSpec.describe MultiplicationEquationConcern do
  let(:random) { Random.new(31_337) }
  let(:dummy_equation_class) do
    Class.new do
      include ActiveModel::API
      include ActiveModel::Attributes
      include MultiplicationEquationConcern

      attribute :random

      def initialize(attributes = {})
        super
      end
    end
  end
  let(:equation) { dummy_equation_class.new(random:) }

  describe "generate_multiplication_numbers" do
    let(:multiplier_range) { 1..9 }
    let(:multiplicand_range) { 1..9 }
    let(:product_range) { 1..20 }
    let(:calculated_multiplicand_range) { 1..20 }

    subject { call_generate_multiplication_numbers }

    it "should return numbers within the original ranges" do
      expect(
        equation.generate_multiplication_numbers(
          multiplier_range,
          multiplicand_range,
          product_range
        )
      ).to eq [8, 2]
    end
  end

  describe "calculate_multiplicand_range" do
    let(:calculated_multiplicand_range) do
      equation.calculate_multiplicand_range(
        multiplier,
        multiplicand_range,
        product_range
      )
    end

    context "product_range is nil" do
      let(:multiplier) { 3 }
      let(:multiplicand_range) { 1..9 }
      let(:product_range) { nil }

      it "leaves the multiplicand range unchanged" do
        expect(calculated_multiplicand_range).to eq 1..9
      end
    end

    context "calculated multiplicand min is higher than the multiplicand min" do
      let(:multiplier) { 3 }
      let(:multiplicand_range) { 1..9 }
      let(:product_range) { 10..30 }

      it "uses the calculated multiplicand min" do
        expect(calculated_multiplicand_range.min).to eq 4
      end
    end

    context "calculated multiplicand max is lower than the multiplicand max" do
      let(:multiplier) { 5 }
      let(:multiplicand_range) { 1..9 }
      let(:product_range) { 1..20 }

      it "uses the calculated multiplicand max" do
        expect(calculated_multiplicand_range.max).to eq 4
      end
    end

    context "calculated multiplicand min is lower than the multiplicand min" do
      let(:multiplier) { 2 }
      let(:multiplicand_range) { 2..9 }
      let(:product_range) { 1..20 }

      it "leaves the multiplicand min unchanged" do
        expect(calculated_multiplicand_range.min).to eq 2
      end
    end

    context "calculated multiplicand max is higher than the multiplicand max" do
      let(:multiplier) { 2 }
      let(:multiplicand_range) { 1..9 }
      let(:product_range) { 1..20 }

      it "leaves the multiplicand max unchanged" do
        expect(calculated_multiplicand_range.max).to eq 9
      end
    end

    context "product_range cannot be satisfied" do
      let(:multiplier) { 2 }
      let(:multiplicand_range) { 4..10 }
      let(:product_range) { 1..6 }

      it "raises a range error" do
        expect { calculated_multiplicand_range }.to raise_error(
          RangeError,
          "Product range is invalid"
        )
      end
    end
  end
end
