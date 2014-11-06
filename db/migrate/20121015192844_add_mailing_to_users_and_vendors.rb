class AddMailingToUsersAndVendors < ActiveRecord::Migration
  def change
  	add_column :users, :mailing, :boolean, :default => true
  	add_column :vendors, :mailing, :boolean, :default => true
  	add_column :vendors, :email2, :string
  end
end
