class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.integer :user_merits_info_id
      t.string :name
      t.string :action_type
      t.string :status, :default => "unstarted"
      t.string :message
      t.integer :score
      t.integer :child_id

      t.timestamps
    end
  end
end
