class Puzzles::MathsGridzilla
  include ActiveModel::API
  include ActiveModel::Attributes
  include RandomInRange

  attribute :rows,                  :integer, default: 4
  attribute :columns,               :integer, default: 6
  attribute :dividends_from,        :integer, default: 1
  attribute :dividends_to,          :integer, default: 1000
  attribute :divisors_from,         :integer, default: 1
  attribute :divisors_to,           :integer, default: 20
  attribute :division_results_min,  :integer, default: 1
  attribute :division_results_max,  :integer, default: 100
  attribute :factors_from,          :integer, default: 1
  attribute :factors_to,            :integer, default: 12
  attribute :factors_count_min,     :integer, default: 2
  attribute :factors_count_max,     :integer, default: 3
  attribute :addition_from,         :integer, default: 10
  attribute :addition_to,           :integer, default: 1000
  attribute :addition_count_min,    :integer, default: 2
  attribute :addition_count_max,    :integer, default: 4
  attribute :addition_result_min,    :integer
  attribute :addition_result_max,    :integer, default: 5000
  attribute :subtraction_from,      :integer, default: 10
  attribute :subtraction_to,        :integer, default: 1000
  attribute :subtraction_count_min, :integer, default: 2
  attribute :subtraction_count_max, :integer, default: 4
  attribute :subtraction_result_min, :integer, default: 0
  attribute :subtraction_result_max, :integer

  validates_presence_of :rows, :columns
  validates_presence_of :dividends_from, :dividends_to
  validates_presence_of :divisors_from, :divisors_to
  validates_presence_of :factors_from, :factors_to
  validates_presence_of :factors_count_min, :factors_count_max
  validate :dividends_from_not_greater_than_to
  validate :divisors_from_not_greater_than_to
  validate :factors_from_not_greater_than_to
  validate :factors_count_min_not_greater_than_max

  def initialize(attributes = {})
    super

    @random = Random.new
  end

  def cells
    @cells ||= rows.times.map do |row|
      columns.times.map do |col|
        case random_cell_type
        when :addition then Equations::Addition.new(**addition_equation_params)
        when :subtraction then Equations::Subtraction.new(**subtraction_equation_params)
        when :multiplication then Equations::Multiplication.new(**multiplication_equation_params)
        when :division then Equations::Division.new(**division_equation_params)
        end
      end
    end
  end

  private

    def addition_equation_params
      {
        count_min:   addition_count_min,
        count_max:   addition_count_max,
        range_start: addition_from,
        range_end:   addition_to,
        result_min:  addition_result_min,
        result_max:  addition_result_max,
        random:      @random
      }
    end

    def subtraction_equation_params
      {
        count_min:   subtraction_count_min,
        count_max:   subtraction_count_max,
        range_start: subtraction_from,
        range_end:   subtraction_to,
        result_min:  subtraction_result_min,
        result_max:  subtraction_result_max,
        random:      @random
      }
    end

    def division_equation_params
      {
        dividends_min: dividends_from,
        dividends_max: dividends_to,
        divisors_min:  divisors_from,
        divisors_max:  divisors_to,
        result_min:    division_results_min,
        result_max:    division_results_max,
        random:        @random
      }
    end

    def multiplication_equation_params
      {
        count_min:   factors_count_min,
        count_max:   factors_count_max,
        range_start: factors_from,
        range_end:   factors_to,
        random:      @random
      }
    end

  def dividends_from_not_greater_than_to
    errors.add(:dividends_from, "cannot be greater than dividends_to") if dividends_from > dividends_to
  end

  def divisors_from_not_greater_than_to
    errors.add(:divisors_from, "cannot be greater than divisors_to") if divisors_from > divisors_to
  end

  def factors_from_not_greater_than_to
    errors.add(:factors_from, "cannot be greater than factors_to") if factors_from > factors_to
  end

  def factors_count_min_not_greater_than_max
    errors.add(:factors_count_min, "cannot be greater than factors_to") if factors_count_min > factors_count_max
  end

  def random_cell_type
    %i[
      addition
      subtraction
      division
      multiplication
    ].sample(random: @random)
  end
end
