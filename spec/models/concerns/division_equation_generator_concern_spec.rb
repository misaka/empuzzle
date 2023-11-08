require "rails_helper"

RSpec.describe DivisionEquationGeneratorConcern do
  let(:random) { Random.new(31_337) }

  let(:equation_class) do
    Class.new do
      include DivisionEquationGeneratorConcern
    end
  end

  # dividend / divisor = quotient

  describe "generate_division_numbers" do
    let(:dividend_range) { 1..20 }
    let(:divisor_range) { 1..10 }
    let(:quotient_range) { 1..10 }
    let(:calculated_quotient_range) { 1..20 }

    subject { call_generate_division_numbers }

    it "should return numbers within the original ranges" do
      expect(
        equation_class.generate_division_numbers(
          dividend_range:,
          divisor_range:,
          quotient_range:,
          random:
        )
      ).to eq [16, 8]
    end

    it "does not require a dividend_range" do
      expect(
        equation_class.generate_division_numbers(
          divisor_range:,
          quotient_range:,
          random:
        )
      ).to eq [56, 8]
    end
  end

  describe "calculate_quotient_range" do
    let(:calculated_quotient_range) do
      equation_class.calculate_quotient_range(dividend_range, divisor, quotient_range)
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
