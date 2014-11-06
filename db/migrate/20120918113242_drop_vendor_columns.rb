class DropVendorColumns < ActiveRecord::Migration

  def self.up
    remove_column :vendors, :addr_region
    remove_column :vendors, :addr_street
    remove_column :vendors, :addr_complement
    remove_column :vendors, :addr_city
    remove_column :vendors, :addr_state
    remove_column :vendors, :addr_zipcode
    remove_column :vendors, :addr_gmaps
    remove_column :vendors, :latitude
    remove_column :vendors, :longitude
    remove_column :vendors, :phone1
    remove_column :vendors, :phone2
  end

  def self.down
    add_column :vendors, :addr_region, :string
    add_column :vendors, :addr_street, :string
    add_column :vendors, :addr_complement, :string
    add_column :vendors, :addr_city, :string
    add_column :vendors, :addr_state, :string
    add_column :vendors, :addr_zipcode, :string
    add_column :vendors, :addr_gmaps, :string
    add_column :vendors, :latitude, :string
    add_column :vendors, :longitude, :string
    add_column :vendors, :phone1, :string
    add_column :vendors, :phone2, :string
  end

end
