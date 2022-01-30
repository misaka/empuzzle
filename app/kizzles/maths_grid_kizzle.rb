class MathsGridKizzle
  DEFAULT_CONFIG = {
    rows: 8,
    columns: 8,

    dividend_min: 1,
    dividend_max: 1000,

    divisor_min: 1,
    divisor_max: 20,

    factor_min: 1,
    factor_max: 12,

    factors_chain_min: 2,
    factors_chain_max: 3,
  }

  def initialize(config_params = {})
    @random = Random.new

    instantiate_config_variables(config_params)
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

  def instantiate_config_variables(config_params)
    config = DEFAULT_CONFIG.merge(config_params)

    DEFAULT_CONFIG.keys.each do |var|
      instance_variable_set("@#{var}", config[var])
    end
  end

  def generate_division_cell
    dividend = @random.rand(@dividend_max).round
    divisor = @random.rand(@divisor_max - 2).round + 2
    OpenStruct.new(
      type: 'division',
      dividend: dividend,
      divisor: divisor
    )
  end

  def generate_multiplication_cell
    factors_count = 2 + @random.rand(@factors_chain_max - 1).round
    factors = factors_count.times.map do |n|
      2 + @random.rand(@factor_max - 1)
    end

    OpenStruct.new(
      type: 'multiplication',
      factors: factors,
      results_length: factors.inject(:*).to_s.length
    )
  end

  def random_cell_type
    types = [:division, :multiplication]

    types[@random.rand(types.length).round]
  end

end
