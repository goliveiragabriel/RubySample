class CreateQuotations < ActiveRecord::Migration
  def change
    create_table :quotations do |t|
      t.integer :id
      t.integer :user_id
      t.string :comments
      t.integer :vendor_id
      t.string :telephone
      t.integer :number_guests
      t.date :wedding_date

      t.timestamps
    end
  end
end
