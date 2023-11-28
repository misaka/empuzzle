class RenamePuzzleTypes < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      UPDATE puzzles SET type = 'Puzzles::Maths::ArithmeticGrid' WHERE type = 'Puzzles::MathsGrid';
      UPDATE puzzles SET type = 'Puzzles::Maths::NumberLineArithmetic' WHERE type = 'Puzzles::NumberLine';
    SQL
  end

  def down
    execute <<~SQL
      UPDATE puzzles SET type = 'Puzzles::MathsGrid' WHERE type = 'Puzzles::Maths::ArithmeticGrid';
      UPDATE puzzles SET type = 'Puzzles::NumberLine' WHERE type = 'Puzzles::Maths::NumberLineArithmetic';
    SQL
  end
end
