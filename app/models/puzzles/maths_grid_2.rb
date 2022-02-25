class Puzzles::MathsGrid2
  include ActiveModel::API
  include ActiveModel::Attributes
  include RandomInRange

    ADDITION_NUMBER_COUNT_OPTIONS = [{
                                     count_min: 2,
                                     count_max: 2,
                                   }, {
                                     count_min: 2,
                                     count_max: 3,
                                   }, {
                                     count_min: 2,
                                     count_max: 4,
                                   }, {
                                     count_min: 3,
                                     count_max: 3,
                                   }, {
                                     count_min: 3,
                                     count_max: 4,
                                   }, {
                                     count_min: 4,
                                     count_max: 4,
                                   }]
  ADDITION_NUMBER_RANGE_OPTIONS = [{
                                     range_start: 2,
                                     range_end: 9,
                                   }, {
                                     range_start: 2,
                                     range_end: 20,
                                   }, {
                                     range_start: 2,
                                     range_end: 50,
                                   }, {
                                     range_start: 2,
                                     range_end: 100,
                                   }]

  SUBTRACTION_NUMBER_COUNT_OPTIONS = [{
                                        count_min: 2,
                                        count_max: 2,
                                      }, {
                                        count_min: 2,
                                        count_max: 3,
                                      }, {
                                        count_min: 2,
                                        count_max: 4,
                                      }, {
                                        count_min: 3,
                                        count_max: 3,
                                      }, {
                                        count_min: 3,
                                        count_max: 4,
                                      }, {
                                        count_min: 4,
                                        count_max: 4,
                                      }]
  SUBTRACTION_NUMBER_RANGE_OPTIONS = [{
                                        range_start: 2,
                                        range_end: 9,
                                      }, {
                                        range_start: 2,
                                        range_end: 20,
                                      }, {
                                        range_start: 2,
                                        range_end: 50,
                                      }, {
                                        range_start: 2,
                                        range_end: 100,
                                      }]

  MULTIPLICATION_NUMBER_COUNT_OPTIONS = [{
                                           count_min: 2,
                                           count_max: 2,
                                         }, {
                                           count_min: 2,
                                           count_max: 3,
                                         }, {
                                           count_min: 2,
                                           count_max: 4,
                                         }, {
                                           count_min: 3,
                                           count_max: 3,
                                         }, {
                                           count_min: 3,
                                           count_max: 4,
                                         }, {
                                           count_min: 4,
                                           count_max: 4,
                                         }]
  MULTIPLICATION_NUMBER_RANGE_OPTIONS = [{
                                           range_start: 2,
                                           range_end: 9,
                                         }, {
                                           range_start: 2,
                                           range_end: 20,
                                         }, {
                                           range_start: 2,
                                           range_end: 50,
                                         }, {
                                           range_start: 2,
                                           range_end: 100,
                                         }]

  DIVISORS_RANGE_OPTIONS = [{
                              divisors_min: 2,
                              divisors_max: 9,
                            }, {
                              divisors_min: 3,
                              divisors_max: 19,
                            }, {
                              divisors_min: 3,
                              divisors_max: 40,
                            }, {
                              divisors_min: 10,
                              divisors_max: 100,
                            }]

  DIVIDENDS_RANGE_OPTIONS = [{
                               dividends_min: 10,
                               dividends_max: 100,
                             }, {
                               dividends_min: 100,
                               dividends_max: 1000,
                             }, {
                               dividends_min: 100,
                               dividends_max: 10000,
                             }]

  attribute :rows,                   :integer, default: 4
  attribute :columns,                :integer, default: 6

  attribute :enable_addition,        :boolean, default: true
  attribute :addition_numbers_count, :integer, default: 0
  attribute :addition_numbers_range, :integer, default: 0

  attribute :enable_subtraction,        :boolean, default: true
  attribute :subtraction_numbers_count, :integer, default: 0
  attribute :subtraction_numbers_range, :integer, default: 0

  attribute :enable_multiplication,        :boolean, default: true
  attribute :multiplication_numbers_count, :integer, default: 0
  attribute :multiplication_numbers_range, :integer, default: 0

  attribute :enable_division, :boolean, default: true
  attribute :dividends_range, :integer, default: 0
  attribute :divisors_range,  :integer, default: 0

  # 300,000 words, 18 bits. 36 bits total for the use of 2-word codes, minus one for a 32 bit random number

  # Puzzle Parameters:
  #
  # ###                                  0-7  columns                  (3-10)
  #    ###                               0-7  rows                     (1-8)
  #       ###                            0-7  addition numbers         (0-0, 2-2, 2-3, 2-4, 3-3, 3-4, 4-4)
  #          ##                          0-3  addition number sizes    (2-9, 2-20, 2-50, 2-100)
  #            ##                        0-3  addition results         (??)
  #              #                       0-1  enable subtraction       (false/true)
  #               ##                     0-3  subtraction numbers      (2-5)
  #                 ##                   0-3  subtraction number sizes (2-9, 2-20, 2-50, 2-100)
  #                   ##                 0-3  subtraction results      (??)
  #                     #                0-1  enable multiplication    (false/true)
  #                      ##              0-3  factors                  (2-5)
  #                        ##            0-3  factor size              (2-9, 2-20, 2-50, 2-100)
  #                          ##          0-3  factor results           (??)
  #                            #         0-1  enable division          (false/true)
  #                             ##       0-3  dividend size            (10-100, 100-1000, 100-10000)
  #                               ##     0-3  divisor size             (2-9, 2-20, 10-100)
  #                                 ##   0-3  division results         (??)
  # ||||||||||||||||||||||||||||||||||||
  #           11111111112222222222333333
  # 012345678901234567890123456789012345
  #
  validates :rows,    presence: true, numericality: { greater_than: 0, less_than: 9 }
  validates :columns, presence: true, numericality: { greater_than: 2, less_than: 11  }

  validates :enable_addition,       inclusion: { in: [true, false] }
  validates :addition_numbers_count, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 7 }
  validates :addition_numbers_range, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 4 }

  validates :enable_subtraction,       inclusion: { in: [true, false] }
  validates :subtraction_numbers_count, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 7 }
  validates :subtraction_numbers_range, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 4 }

  validates :enable_multiplication, inclusion: { in: [true, false] }
  validates :multiplication_numbers_count, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 7 }
  validates :multiplication_numbers_range, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 4 }

  validates :enable_division,  inclusion: { in: [true, false] }
  validates :dividends_range,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 4 }
  validates :divisors_range,   presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 4 }

  def self.addition_numbers_options
    []
  end

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
      params = { random: @random }
      params.merge!(ADDITION_NUMBER_COUNT_OPTIONS[addition_numbers_count])
      params.merge!(ADDITION_NUMBER_RANGE_OPTIONS[addition_numbers_range])
      params.merge(
        result_min: 0,
        result_max: 5000,
      )
    end

    def subtraction_equation_params
      params = { random: @random }
      params.merge!(SUBTRACTION_NUMBER_COUNT_OPTIONS[subtraction_numbers_count])
      params.merge!(SUBTRACTION_NUMBER_RANGE_OPTIONS[subtraction_numbers_range])
      params.merge(
        result_min: 0,
        result_max: nil,
      )
    end

    def multiplication_equation_params
      params = { random: @random }
      params.merge!(MULTIPLICATION_NUMBER_COUNT_OPTIONS[multiplication_numbers_count])
      params.merge!(MULTIPLICATION_NUMBER_RANGE_OPTIONS[multiplication_numbers_range])
      params.merge(
        result_min: 0,
        result_max: nil,
      )
    end

    def division_equation_params
      params = { random: @random }
      params.merge!(DIVIDENDS_RANGE_OPTIONS[dividends_range])
      params.merge!(DIVISORS_RANGE_OPTIONS[divisors_range])
      params.merge(
        result_min: 0,
        result_max: nil,
      )
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
    cell_types = []
    cell_types << :addition       if enable_addition
    cell_types << :subtraction    if enable_subtraction
    cell_types << :multiplication if enable_multiplication
    cell_types << :division       if enable_division

    cell_types.sample(random: @random)
  end
end
