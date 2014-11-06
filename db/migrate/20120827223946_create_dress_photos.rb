class CreateDressPhotos < ActiveRecord::Migration
  def change
    create_table :dress_photos do |t|
      t.integer :dress_id
      t.string :image
      t.text :name
      t.boolean :cover, :default => false

      t.timestamps
    end
  end
end
