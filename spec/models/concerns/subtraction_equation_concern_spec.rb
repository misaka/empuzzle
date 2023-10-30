require "rails_helper"



RSpec.describe SubtractionEquationConcern do
  let(:random) { Random.new(31_337) }
  let(:result_decimal_places) { nil }
  let(:dummy_equation_class) do
    Class.new do
      include ActiveModel::API
      include ActiveModel::Attributes
      include SubtractionEquationConcern

      attribute :random
      # attribute :minuend_range
      # attribute :subtrahend_range
      # attribute :result_decimal_places
      # attribute :difference_range
      # attribute :type

      def initialize(attributes = {})
        super
      end
    end
  end

  let(:equation) { dummy_equation_class.new(random:) }

  # before do
  #   allow(random).to receive(:rand).and_invoke(
  #     ->(r) {
  #       {
  #         minuend_range => minuend,
  #         calculated_difference_range => difference
  #       }.fetch(r)
  #     }
  #   )
  # end

  describe "calculate_difference_range" do
    let(:calculate_difference_range) do
      equation.calculate_difference_range(
        minuend,
        subtrahend_range,
        difference_range
      )
    end

    context "calculated difference min is lower than the supplied difference min" do
      let(:minuend) { 8 }
      let(:subtrahend_range) { 5..9 }
      let(:difference_range) { 1..5 }

      it "uses the supplied difference min" do
        expect(calculate_difference_range.min).to eq difference_range.min
      end
    end

    context "calculated difference min is higher than the supplied difference min" do
      let(:minuend) { 8 }
      let(:subtrahend_range) { 1..5 }
      let(:difference_range) { 1..5 }

      it "uses the calculated difference min" do
        expect(calculate_difference_range.min).to eq 3
      end
    end

    context "calculated difference max is higher than the supplied difference min" do
      let(:minuend) { 8 }
      let(:subtrahend_range) { 1..5 }
      let(:difference_range) { 1..5 }

      it "uses the supplied difference max" do
        expect(calculate_difference_range.max).to eq difference_range.max
      end
    end

    context "calculated difference max is lower than the supplied difference min" do
      let(:minuend) { 8 }
      let(:subtrahend_range) { 5..9 }
      let(:difference_range) { 1..5 }

      it "uses the calculated difference max" do
        expect(calculate_difference_range.max).to eq 3
      end
    end

    context "difference range cannot be satisfied" do
      let(:minuend) { 9 }
      let(:subtrahend_range) { 1..2 }
      let(:difference_range) { 1..5 }
      # calculated min is 7
      # calculated max is 8, becomes 5

      it "raises a range error" do
        expect { calculate_difference_range }.to(
          raise_error(
            RangeError,
            "Difference range is invalid"
          )
        )
      end
    end
  end

  describe "generate_subtraction_numbers" do
    let(:minuend_range) { 2..10 }
    let(:subtrahend_range) { 1..6 }
    let(:difference_range) { 1..5 }
    let(:calculated_difference_range) { 3..5 }

    it "returns numbers within the ranges" do
      expect(
        equation.generate_subtraction_numbers(
          minuend_range,
          subtrahend_range,
          difference_range
        )
      ).to eq [9, 4]
    end
  end
end
