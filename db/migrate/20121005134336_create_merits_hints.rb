class CreateMeritsHints < ActiveRecord::Migration
  def change
    create_table :merits_hints do |t|
      t.integer :merit_id
      t.integer :hint_id

      t.timestamps
    end
  end
end
