require "rails_helper"

class DummySubtractionEquation
  include ActiveModel::API
  include ActiveModel::Attributes
  include SubtractionEquationConcern

  attribute :random
  attribute :minuend_range
  attribute :subtrahend_range
  attribute :result_decimal_places
  attribute :difference_range
  attribute :type

  def initialize(attributes = {})
    super
  end
end

RSpec.describe SubtractionEquationConcern do
  let(:random) { Random.new(31_337) }
  let(:minuend_range) { 2..10 }
  let(:subtrahend_range) { 2..10 }
  let(:result_decimal_places) { nil }
  let(:difference_range) { 1..5 }

  let(:equation) do
    DummySubtractionEquation.new(
      random:,
      minuend_range:,
      subtrahend_range:,
      result_decimal_places:,
      difference_range:,
      type: "subtraction"
    )
  end

  before do
    allow(random).to receive(:rand).and_invoke(
      ->(r) {
        {
          minuend_range => minuend,
          calculated_difference_range => difference
        }.fetch(r)
      }
    )
  end

  let(:calculate_difference_range) do
    equation.calculate_difference_range(
      minuend,
      minuend_range,
      difference_range
    )
  end

  context "high minuend unchanged result range: 8 - 5 = 3" do
    let(:minuend) { 8 }
    let(:calculated_difference_range) { 1..5 }
    let(:difference) { 3 }

    describe "calculate_difference_range" do
      subject { calculate_difference_range }
      it { should eq calculated_difference_range }
    end

    describe "generate_subtraction_numbers" do
      subject do
        equation.generate_subtraction_numbers(
          minuend_range,
          subtrahend_range,
          difference_range
        )
      end
      it { should eq [8, 5] }
    end
  end

  context "low minuend lowers result max: 4 - 3 = 1" do
    let(:minuend) { 4 }
    let(:calculated_difference_range) { 1..2 }
    let(:difference) { 1 }

    describe "calculate_difference_range" do
      subject { calculate_difference_range }
      it { should eq calculated_difference_range }
    end

    describe "generate_subtraction_numbers" do
      subject do
        equation.generate_subtraction_numbers(
          minuend_range,
          subtrahend_range,
          difference_range
        )
      end
      it { should eq [4, 3] }
    end
  end

  context "minuend forces subtrahend too lower bound: 3 - 2 = 1" do
    let(:minuend) { 3 }
    let(:calculated_difference_range) { 1..1 }
    let(:difference) { 1 }

    describe "calculate_difference_range" do
      subject { calculate_difference_range }
      it { should eq calculated_difference_range }
    end

    describe "generate_subtraction_numbers" do
      subject do
        equation.generate_subtraction_numbers(
          minuend_range,
          subtrahend_range,
          difference_range
        )
      end
      it { should eq [3, 2] }
    end
  end

  context "low minuend forces lowering of subtrahend range: 2 - 1 = 1" do
    let(:minuend) { 2 }
    let(:calculated_difference_range) { 1..1 }
    let(:difference) { 1 }

    describe "calculate_difference_range" do
      subject { calculate_difference_range }
      it { should eq calculated_difference_range }
    end

    describe "generate_subtraction_numbers" do
      subject do
        equation.generate_subtraction_numbers(
          minuend_range,
          subtrahend_range,
          difference_range
        )
      end
      it { should eq [2, 1] }
    end
  end
end
