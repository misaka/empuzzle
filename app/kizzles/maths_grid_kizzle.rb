class MathsGridKizzle
  def initialize(config_params = {})
    @random = Random.new
    @config = maths_grid_config(config_params)
    @config.cols = config_params[:cols]
    @config.rows = config_params[:rows]
  end

  def cells
    @cells ||= begin
                 cells = Array.new(@config.rows) { Array.new(@config.cols) }

                 @config.rows.times do |row|
                   @config.cols.times do |col|
                     cells[row][col] = case random_cell_type
                                       when :division then generate_division_cell
                                       when :multiplication then generate_multiplication_cell
                                       end
                   end
                 end

                 cells
               end
  end

  private

  def maths_grid_config(params)
    OpenStruct.new(
      division: OpenStruct.new(
        dividend_max: params.fetch(:dividend_max, 1000),
        divisor_max: params.fetch(:divisor_max, 20)
      ),
      multiplication: OpenStruct.new(
        max_factors_count: params.fetch(:max_factors_count, 3),
        factor_max: params.fetch(:factor_max, 12)
      )
    )
  end

  def generate_division_cell
    dividend = @random.rand(@config.division.dividend_max).round
    divisor = @random.rand(@config.division.divisor_max - 2).round + 2
    OpenStruct.new(
      type: 'division',
      dividend: dividend,
      divisor: divisor
    )
  end

  def generate_multiplication_cell
    factors_count = 2 + @random.rand(@config.multiplication.max_factors_count - 1).round
    factors = factors_count.times.map do |n|
      2 + @random.rand(@config.multiplication.factor_max - 1)
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
