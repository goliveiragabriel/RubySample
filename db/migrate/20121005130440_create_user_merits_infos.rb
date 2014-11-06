class CreateUserMeritsInfos < ActiveRecord::Migration
  def change
    create_table :user_merits_infos do |t|
      t.integer :user_id
      t.integer :merit_id
      t.integer :points
      t.boolean :closed

      t.timestamps
    end
  end
end
