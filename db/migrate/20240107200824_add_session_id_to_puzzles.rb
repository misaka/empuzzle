class AddSessionIdToPuzzles < ActiveRecord::Migration[7.0]
  def change
    add_column :puzzles, :session_id, :uuid
  end
end
