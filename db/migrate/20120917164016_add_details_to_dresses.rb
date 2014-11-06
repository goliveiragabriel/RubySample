class AddDetailsToDresses < ActiveRecord::Migration
  def change
  	add_column :dresses, :details, :text
  end
end
