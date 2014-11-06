class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :vendor_id
      t.string :name
      t.string :street
      t.string :complement
      t.string :district
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :region
      t.string :gmaps
      t.float :latitude
      t.float :longitude
      t.string :phone1
      t.string :phone2

      t.timestamps
    end
  end
end