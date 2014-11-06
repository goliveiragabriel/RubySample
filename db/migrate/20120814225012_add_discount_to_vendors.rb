class AddDiscountToVendors < ActiveRecord::Migration
  def self.up
    add_column :vendors, :discount, :boolean
    add_column :vendors, :discount_title, :string
    add_column :vendors, :discount_description, :text
    add_column :vendors, :off_listing_reason, :string
  end

  def self.down
    remove_column :vendors, :discount
    remove_column :vendors, :discount_title
    remove_column :vendors, :discount_description
    remove_column :vendors, :off_listing_reason
  end

end