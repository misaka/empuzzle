class Puzzles::Maths::ArithmeticGrid::TimesTable < Puzzles::Maths::ArithmeticGrid
  jsonb_accessor :config, number: :integer, rows: :integer

  def self.levels_configs
    @levels_configs ||= HashWithIndifferentAccess.new(
      {
        "ages_6_to_7" => {
          numbers: 2..4,
          row_sizes: {
            small: 6,
            medium: 8,
            large: 10
          }
        },
        "ages_7_to_8" => {
          numbers: 2..8,
          row_sizes: {
            small: 8,
            medium: 10,
            large: 12
          }
        }
      }
    )
  end

  def generate_puzzle
    self.number = level_config[:numbers].to_a.sample(random:)
    self.rows = level_config[:row_sizes][size]

    generate_data
  end

  def generate_data
    super
  end

  def to_s
    I18n.t(
      "puzzles.maths.arithmetic_grid.times_table.to_s",
      number: number,
      level: self.class.human_attribute_name(level),
      size: self.class.human_attribute_name(size),
      rows: rows
    )
  end

  private

  def set_defaults
    self.seed ||= rand(2**32)
  end

  def generate_cells
    equations = Set.new

    rows.times.map do |row|
      multiplier = row + 1
      [
        ::Equation.new(
          type: :multiplication,
          numbers: [multiplier, number],
          result: [multiplier * number]
        ).tap do |eq|
          equations.add(eq.to_h)
        end
      ]
    end
  end
end
