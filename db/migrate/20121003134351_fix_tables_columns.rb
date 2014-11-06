class FixTablesColumns < ActiveRecord::Migration
  def change
    add_column :appointments, :telephone, :string
    rename_column :searches, :addr_region, :search_source
    remove_column :vendors, :phone1
    remove_column :vendors, :phone2
  end
end
