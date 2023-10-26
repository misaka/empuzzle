require "rails_helper"

RSpec.describe DivisionEquationConcern do
  let(:random) { Random.new(31_337) }

  let(:dummy_equation_class) do
    Class.new do
      include ActiveModel::API
      include ActiveModel::Attributes
      include DivisionEquationConcern

      attribute :random

      def initialize(attributes = {})
        super
      end
    end
  end
  let(:equation) { dummy_equation_class.new(random:) }

  # dividend / divisor = quotient
  describe "generate_division_numbers" do
    let(:dividend_range) { 1..20 }
    let(:divisor_range) { 1..10 }
    let(:quotient_range) { 1..10 }
    let(:calculated_quotient_range) { 1..20 }

    subject { call_generate_division_numbers }

    it "should return numbers within the original ranges" do
      expect(
        equation.generate_division_numbers(
          dividend_range,
          divisor_range,
          quotient_range
        )
      ).to eq [16, 8]
    end
  end

  describe "calculate_quotient_range" do
    let(:calculated_quotient_range) do
      equation.calculate_quotient_range(dividend_range, divisor, quotient_range)
    end

    context "calculated quotient min is higher than the supplied quotient min" do
      let(:dividend_range) { 4..20 }
      let(:divisor) { 2 }
      let(:quotient_range) { 1..10 }

      it "uses the calculated quotient min, rounded up" do
        expect(calculated_quotient_range.min).to eq 2.0
      end
    end

    context "calculated quotient max is lower than the supplied quotient max" do
      let(:dividend_range) { 1..20 }
      let(:divisor) { 6 }
      let(:quotient_range) { 1..10 }

      it "uses the calculated quotient max, rounded down" do
        expect(calculated_quotient_range.max).to eq 3.0
      end
    end

    context "calculated quotient min is lower than the supplied quotient min" do
      let(:dividend_range) { 4..20 }
      let(:divisor) { 2 }
      let(:quotient_range) { 5..10 }

      it "returns the quotient min" do
        expect(calculated_quotient_range.min).to eq 5.0
      end

      context "quotient_range is nil" do
        let(:quotient_range) { nil }

        it "uses the calculated quotient min, rounded up" do
          expect(calculated_quotient_range.min).to eq 2.0
        end
      end
    end

    context "calculated quotient max is higher than the supplied quotient max" do
      let(:dividend_range) { 1..20 }
      let(:divisor) { 2 }
      let(:quotient_range) { 1..6 }

      it "returns the quotient max" do
        expect(calculated_quotient_range.max).to eq 6.0
      end

      context "quotient_range is nil" do
        let(:quotient_range) { nil }

        it "uses the calculated quotient max, rounded down" do
          expect(calculated_quotient_range.max).to eq 10.0
        end
      end
    end

    context "dividend_range is nil" do
      let(:dividend_range) { nil }
      let(:divisor) { 2 }
      let(:quotient_range) { 1..10 }

      it "uses the quotient range" do
        expect(calculated_quotient_range).to eq 1..10
      end
    end

    context "quotient_range cannot be satisfied" do
      let(:dividend_range) { 1..9 }
      let(:divisor) { 6 }
      let(:quotient_range) { 2..10 }

      it "raises a range error" do
        expect { calculated_quotient_range }.to raise_error(
          RangeError,
          "Quotient range is invalid"
        )
      end
    end
  end
end
