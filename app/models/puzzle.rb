# == Schema Information
#
# Table name: puzzles
#
#  id         :bigint           not null, primary key
#  config     :jsonb
#  data       :jsonb
#  level      :integer
#  reward     :text
#  seed       :bigint
#  size       :integer
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :uuid
#
class Puzzle < ApplicationRecord
  before_create :generate_puzzle

  def generate_puzzle
    raise NotImplementedError,
          "Please implement #generate_puzzle. This should populate the data field with the puzzle data."
  end

  def self.default_size
    :medium
  end

  enum :size, %i[small medium large], default: default_size

  def default_size
    self.class.default_size
  end

  def puzzle_type
    type.underscore.sub("puzzles/", "")
  end

  def puzzle_dotpath
    puzzle_type.gsub("/", ".")
  end

  def to_s
    I18n.t(
      "puzzles.#{puzzle_dotpath}.to_s",
      level: self.class.human_attribute_name(level),
      size: self.class.human_attribute_name(size),
      dimensions: dimensions_text
    )
  end

  def type_name
    I18n.t("puzzles.#{puzzle_dotpath}.type_name")
  end
end
