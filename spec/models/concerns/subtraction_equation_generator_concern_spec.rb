require "rails_helper"

RSpec.describe SubtractionEquationGeneratorConcern do
  let(:random) { Random.new(31_337) }

  let(:dummy_class) do
    Class.new { include SubtractionEquationGeneratorConcern }
  end

  # minuend - subtrahend = difference

  describe "generate_subtraction_numbers" do
    let(:minuend_range) { 2..10 }
    let(:subtrahend_range) { 1..9 }
    let(:difference_range) { 1..5 }
    let(:calculated_difference_range) { 3..5 }

    it "returns numbers within the ranges" do
      expect(
        dummy_class.generate_subtraction_numbers(
          minuend_range:,
          subtrahend_range:,
          difference_range:,
          random:
        )
      ).to eq [9, 5]
    end
  end

  describe "calculate_subtrahend_range" do
    let(:minuend) { 8 }
    let(:minuend_range) { 2..10 }
    let(:subtrahend_range) { 1..6 }
    let(:difference_range) { 1..5 }

    let(:calculate_subtrahend_range) do
      dummy_class.calculate_subtrahend_range(
        minuend,
        minuend_range,
        subtrahend_range,
        difference_range
      )
    end

    context "no difference range supplied" do
      let(:minuend) { 8 }
      let(:difference_range) { nil }

      it "uses the supplied subtrahend range" do
        expect(calculate_subtrahend_range).to eq subtrahend_range
      end
    end

    context "calculated subtrahend min is lower than the supplied subtrahend min" do
      let(:minuend) { 8 }
      let(:subtrahend_range) { 5..9 }
      let(:difference_range) { 1..6 }

      it "uses the supplied subtrahend min" do
        expect(calculate_subtrahend_range.min).to eq subtrahend_range.min
      end
    end

    context "calculated subtrahend min is higher than the supplied subtrahend min" do
      let(:minuend) { 8 }
      let(:subtrahend_range) { 1..5 }
      let(:difference_range) { 1..5 }

      it "uses the calculated subtrahend min" do
        expect(calculate_subtrahend_range.min).to eq 3
      end
    end

    context "calculated subtrahend max is higher than the supplied subtrahend min" do
      let(:minuend) { 8 }
      let(:subtrahend_range) { 1..5 }
      let(:difference_range) { 1..5 }

      it "uses the supplied subtrahend max" do
        expect(calculate_subtrahend_range.max).to eq subtrahend_range.max
      end
    end

    context "calculated subtrahend max is lower than the supplied subtrahend min" do
      let(:minuend) { 8 }
      let(:subtrahend_range) { 5..9 }
      let(:difference_range) { 1..5 }

      it "uses the calculated subtrahend max" do
        expect(calculate_subtrahend_range.max).to eq 7
      end
    end

    context "subtrahend range cannot be satisfied" do
      let(:minuend) { 9 }
      let(:subtrahend_range) { 1..2 }
      let(:difference_range) { 1..5 }
      # calculated min is 7
      # calculated max is 8, becomes 5

      it "raises a range error" do
        expect { calculate_subtrahend_range }.to(
          raise_error(
            RangeError,
            "Subtrahend range is invalid, 4 cannot be more than 2"
          )
        )
      end
    end
  end
end
