class NumberLineMathsPuzzle
  include ActiveModel::API
  include ActiveModel::Attributes
  include RandomInRange

  attribute :rows,                       :integer, default: 6
  attribute :reward,                     :string
  attribute :line_range_from,            :integer, default: 0
  attribute :line_range_to,              :integer, default: 10
  attribute :addition_numbers_count_min, :integer, default: 2
  attribute :addition_numbers_count_max, :integer, default: 2
  attribute :addition_numbers_from,      :integer, default: 1
  attribute :addition_numbers_to,        :integer, default: 10

  def initialize(attributes = {})
    super

    @random = Random.new
  end

  def lines
    @lines ||= rows.times.map do |_row|
      case random_exercise_type
      when :addition then generate_addition_exercise
      end
    end
  end

  private

  def random_exercise_type
    %i[
      addition
    ].sample(random: @random)
  end

  def generate_addition_exercise
    numbers = addition_numbers

    OpenStruct.new(
      type: :addition,
      numbers: numbers,
      results_length: numbers.inject(:+).to_s.length
    )
  end

  def addition_numbers
    number_count = random_in_range(
      addition_numbers_count_min,
      addition_numbers_count_max
    )

    begin
      numbers = number_count.times.map do
        random_in_range(addition_numbers_from, addition_numbers_to)
      end

      result = numbers.inject(:+)
    end until result <= line_range_to

    numbers
  end
end
