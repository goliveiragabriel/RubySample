class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :name
      t.string :service_type
      t.string :vendor_name
      t.string :address
      t.string :addr_region
      t.integer :distance
      t.string :sort_by
      t.boolean :filter
      t.string :price
      t.string :ip_address
      t.integer :user_id

      t.timestamps
    end
  end
end
