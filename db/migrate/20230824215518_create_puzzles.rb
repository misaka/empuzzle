class CreatePuzzles < ActiveRecord::Migration[7.0]
  def change
    create_table :puzzles do |t|
      t.string :type
      t.jsonb :config
      t.text :reward

      t.timestamps
    end
  end
end
