class DropServicesTables < ActiveRecord::Migration
  def self.up
    drop_table :bands
    drop_table :beauties
    drop_table :cakes
    drop_table :caterings
    drop_table :decorations
    drop_table :djs
    drop_table :dresses
    drop_table :gifts
    drop_table :invitations
    drop_table :jewelries
    drop_table :others
    drop_table :photographies
    drop_table :travels
    drop_table :venues

    remove_index :vendors, [:service_id, :service_type]
    remove_column :vendors, :service_id
    remove_column :vendors, :service_type
  end
end