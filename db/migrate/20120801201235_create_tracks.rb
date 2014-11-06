class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :id
      t.integer :user_id
      t.integer :vendor_id
      t.string :ip
      t.string :action

      t.timestamps
    end
  end
end
