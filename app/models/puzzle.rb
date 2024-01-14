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
#  size       :integer          not null
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :uuid
#
class Puzzle < ApplicationRecord
  enum :size, %i[small medium large]

  def default_size
    :medium
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
