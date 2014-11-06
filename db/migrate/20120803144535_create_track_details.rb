class CreateTrackDetails < ActiveRecord::Migration
  def change
    create_table :track_exits do |t|
      t.integer :track_id
      t.string :url

      t.timestamps
    end
  end
end
