require "rails_helper"

RSpec.describe AdditionEquationConcern do
  let(:random) { Random.new(31_337) }
  let(:dummy_equation_class) do
    Class.new do
      include ActiveModel::API
      include ActiveModel::Attributes
      include AdditionEquationConcern

      attribute :random

      def initialize(attributes = {})
        super
      end
    end
  end
  let(:equation) { dummy_equation_class.new(random:) }

  describe "generate_addition_numbers" do
    let(:augend_range) { 1..9 }
    let(:addend_range) { 1..9 }
    let(:sum_range) { 1..20 }
    let(:calculated_addend_range) { 1..20 }

    subject { call_generate_addition_numbers }

    it "should return numbers within the original ranges" do
      expect(
        equation.generate_addition_numbers(
          augend_range,
          addend_range,
          sum_range
        )
      ).to eq [8, 7]
    end
  end

  describe "calculate_addend_range" do
    let(:calculated_addend_range) do
      equation.calculate_addend_range(
        augend,
        addend_range,
        sum_range
      )
    end

    context "sum_range is nil" do
      let(:augend) { 3 }
      let(:addend_range) { 1..9 }
      let(:sum_range) { nil }

      it "leaves the addend range unchanged" do
        expect(calculated_addend_range).to eq 1..9
      end
    end

    context "calculated addend min is higher than the addend min" do
      let(:augend) { 3 }
      let(:addend_range) { 1..9 }
      let(:sum_range) { 5..20 }

      it "uses the calculated addend min" do
        expect(calculated_addend_range.min).to eq 2
      end
    end

    context "calculated addend max is lower than the addend max" do
      let(:augend) { 5 }
      let(:addend_range) { 1..9 }
      let(:sum_range) { 2..10 }

      it "uses the calculated addend max" do
        expect(calculated_addend_range.max).to eq 5
      end
    end

    context "calculated addend min is lower than the addend min" do
      let(:augend) { 12 }
      let(:addend_range) { 1..90 }
      let(:sum_range) { 10..100 }

      it "leaves the addend min unchanged" do
        expect(calculated_addend_range.min).to eq 1
      end
    end

    context "calculated addend max is higher than the addend max" do
      let(:augend) { 2 }
      let(:addend_range) { 1..9 }
      let(:sum_range) { 1..20 }

      it "leaves the addend max unchanged" do
        expect(calculated_addend_range.max).to eq 9
      end
    end

    context "sum_range cannot be satisfied" do
      let(:augend) { 8 }
      let(:addend_range) { 4..18 }
      let(:sum_range) { 1..10 }

      it "raises a range error" do
        expect { calculated_addend_range }.to raise_error(
          RangeError,
          "Addend range is invalid"
        )
      end
    end
  end
end
