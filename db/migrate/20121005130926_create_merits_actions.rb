class CreateMeritsActions < ActiveRecord::Migration
  def change
    create_table :merits_actions do |t|
      t.integer :user_merits_info_id
      t.integer :score
      t.string :action
      t.string :description

      t.timestamps
    end
  end
end
