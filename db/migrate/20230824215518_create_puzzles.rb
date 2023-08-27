class CreatePuzzles < ActiveRecord::Migration[7.0]
  def change
    create_table :puzzles do |t|
      t.string :type, null: false
      t.jsonb :config
      t.jsonb :data
      t.integer :level
      t.text :reward
      t.bigint :seed

      t.timestamps
    end
  end
end
