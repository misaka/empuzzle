class Puzzles::Maths::ArithmeticGrid::TimesTable < Puzzles::Maths::ArithmeticGrid
  jsonb_accessor :config,
                 numbers: [:integer, { array: true }],
                 rows: :integer,
                 columns: :integer

  def self.levels_configs
    @levels_configs ||=
      HashWithIndifferentAccess.new(
        {
          "ages_6_to_7" => {
            numbers: 2..4,
            row_sizes: {
              small: 6,
              medium: 8,
              large: 10
            },
            col_sizes: {
              small: 1,
              medium: 2,
              large: 3
            }
          },
          "ages_7_to_8" => {
            numbers: 2..8,
            row_sizes: {
              small: 8,
              medium: 10,
              large: 12
            },
            col_sizes: {
              small: 1,
              medium: 2,
              large: 3
            }
          }
        }
      )
  end

  def generate_puzzle
    self.rows = level_config[:row_sizes][size]
    self.columns = level_config[:col_sizes][size]
    self.numbers = level_config[:numbers].to_a.shuffle(random:).take(columns)

    generate_data
  end

  def to_s
    I18n.t(
      "puzzles.maths.arithmetic_grid.times_table.to_s",
      numbers: numbers.to_sentence,
      level: self.class.human_attribute_name(level),
      size: self.class.human_attribute_name(size),
      dimensions: dimensions_text
    )
  end

  private

  def set_defaults
    self.seed ||= rand(2**32)
  end

  def generate_cells
    equations = Set.new

    numbers
      .map do |number|
        rows.times.map do |row|
          multiplier = row + 1
          ::Equation
            .new(
              type: :multiplication,
              numbers: [multiplier, number],
              result: [multiplier * number]
            )
            .tap { |eq| equations.add(eq.to_h) }
        end
      end
      .transpose
  end
end
