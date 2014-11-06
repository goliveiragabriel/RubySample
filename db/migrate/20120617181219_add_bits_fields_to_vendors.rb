class AddBitsFieldsToVendors < ActiveRecord::Migration
  def self.up
    add_column :vendors, :venue_details, :integer, :default => 0, :null => false
    add_column :vendors, :catering_details, :integer, :default => 0, :null => false
    add_column :vendors, :photography_details, :integer, :default => 0, :null => false
    add_column :vendors, :invitation_details, :integer, :default => 0, :null => false
    add_column :vendors, :travel_details, :integer, :default => 0, :null => false
    add_column :vendors, :band_details, :integer, :default => 0, :null => false
    add_column :vendors, :gift_details, :integer, :default => 0, :null => false
    add_column :vendors, :beauty_details, :integer, :default => 0, :null => false
    add_column :vendors, :jewelry_details, :integer, :default => 0, :null => false
    add_column :vendors, :dress_details, :integer, :default => 0, :null => false
    add_column :vendors, :decoration_details, :integer, :default => 0, :null => false
    add_column :vendors, :cake_details, :integer, :default => 0, :null => false
    add_column :vendors, :planner_details, :integer, :default => 0, :null => false
    add_column :vendors, :other_details, :integer, :default => 0, :null => false
    add_column :vendors, :type, :string
    add_column :vendors, :details_field1, :string
    add_column :vendors, :details_field2, :text
    add_column :vendors, :details_field3, :integer
    add_column :vendors, :active, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :vendors, :venue_details
    remove_column :vendors, :catering_details
    remove_column :vendors, :photography_details
    remove_column :vendors, :invitation_details
    remove_column :vendors, :travel_details
    remove_column :vendors, :band_details
    remove_column :vendors, :gift_details
    remove_column :vendors, :beauty_details
    remove_column :vendors, :jewelry_details
    remove_column :vendors, :dress_details
    remove_column :vendors, :decoration_details
    remove_column :vendors, :cake_details
    remove_column :vendors, :planner_details
    remove_column :vendors, :other_details
    remove_column :vendors, :type
    remove_column :vendors, :details_field1
    remove_column :vendors, :details_field2
    remove_column :vendors, :details_field3
    remove_column :vendors, :active
  end

end