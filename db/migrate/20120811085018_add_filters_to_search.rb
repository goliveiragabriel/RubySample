class AddFiltersToSearch < ActiveRecord::Migration
  def up
    add_column :searches, :filter_details1, :integer, :default => 0, :null => false
    add_column :searches, :filter_details2, :string
    change_column :searches, :filter, :integer, :default => 0
  end

  def down
    remove_column :searches, :filter_details1
    remove_column :searches, :filter_details2
    change_column :searches, :filter, :boolean
  end
end