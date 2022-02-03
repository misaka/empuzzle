class MathsGridPuzzle
  include ActiveModel::API

  PREDEFINED_CONFIGS = {
    default: {
      rows: 4,
      columns: 6,

      dividends_from: 1,
      dividends_to: 1000,

      divisors_from: 1,
      divisors_to: 20,

      factors_from: 1,
      factors_to: 12,

      factors_count_min: 2,
      factors_count_max: 3,
    }
  }

  attr_accessor :rows, :columns,
                :dividends_from, :dividends_to,
                :divisors_from, :divisors_to,
                :factors_from, :factors_to,
                :factors_count_min, :factors_count_max

  def initialize(config_params = {})
    super

    config = PREDEFINED_CONFIGS[:default]
    config.each do |attr, value|
      send("#{attr}=", value) unless instance_variable_defined? "@#{attr}"
    end

    @random = Random.new
  end

  def cells
    @cells ||= @rows.times.map do |row|
      @columns.times.map do |col|
        case random_cell_type
        when :division then generate_division_cell
        when :multiplication then generate_multiplication_cell
        end
      end
    end
  end

  private

  def generate_division_cell
    OpenStruct.new(
      type: 'division',
      dividend: dividend,
      divisor: divisor
    )
  end

  def generate_multiplication_cell
    factors = factors_count.times.map { factor }

    OpenStruct.new(
      type: 'multiplication',
      factors: factors,
      results_length: factors.inject(:*).to_s.length
    )
  end

  def random_cell_type
    types = %i[division multiplication]

    types[@random.rand(types.length).round]
  end

  def random_in_range(from, to)
    range = to - from

    if range.zero?
      to
    else
      from + @random.rand(range).round
    end
  end

  def factors_count
    random_in_range(@factors_count_min, @factors_count_max)
  end

  def factor
    random_in_range(@factors_from, @factors_to)
  end

  def dividend
    random_in_range(@dividends_from, @dividends_to)
  end

  def divisor
    random_in_range(@divisors_from, @divisors_to)
  end
end
