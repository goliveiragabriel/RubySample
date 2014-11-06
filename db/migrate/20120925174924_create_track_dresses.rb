class CreateTrackDresses < ActiveRecord::Migration
  def change
    create_table :track_dresses do |t|
      t.integer :user_id
      t.integer :dress_id

      t.timestamps
    end
  end
end
