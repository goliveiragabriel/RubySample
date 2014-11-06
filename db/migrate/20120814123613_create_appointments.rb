class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :data
      t.integer :dress_id
      t.integer :user_id
      t.integer :vendor_id

      t.timestamps
    end
  end
end
