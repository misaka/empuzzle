class AddSizesToPuzzlesGrid < ActiveRecord::Migration[7.0]
  def up
    add_column :puzzles, :size, :integer

    connection.execute("UPDATE puzzles SET size = 1 WHERE size IS NULL")
  end

  def down
    remove_column :puzzles, :size
  end
end
