class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :vendor_id
      t.string :image
      t.text :name
      t.boolean :cover, :default => false

      t.timestamps
    end
  end
end
