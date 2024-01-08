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
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :uuid
#
class Puzzle < ApplicationRecord
  def puzzle_type
    type.underscore.sub("puzzles/", "")
  end

  def type_name
    I18n.t("puzzles.#{puzzle_type.gsub("/", ".")}.type_name")
  end
end
