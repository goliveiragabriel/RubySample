class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.text :description
      t.string :website
      t.string :email
      t.string :phone1
      t.string :phone2
      t.string :type, :null => false, :limit => 20
      t.string :addr_region
      t.string :addr_street
      t.string :addr_complement
      t.string :addr_city
      t.string :addr_state
      t.string :addr_zipcode
      t.string :addr_gmaps
      t.float :latitude
      t.float :longitude
      t.string :slug
      t.integer :featured
      t.string :price
      t.text :price_details

      t.timestamps
    end
    
    add_index :vendors, :slug
  end
end
