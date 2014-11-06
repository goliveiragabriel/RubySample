class CreateDresses < ActiveRecord::Migration
  def change
    create_table :dresses do |t|
      t.integer :vendor_id
      t.string :name, :unique => true
      t.string :brand
      t.string :description
      t.integer :featured
      t.integer :share, :default => 0
      t.integer :price
      t.float :weight
      t.string :sleeve
      t.string :finish
      t.string :neckline
      t.string :silhouette
      t.string :train
      t.string :fabric
      t.string :length
      t.string :color

      t.timestamps
    end

  end
end
