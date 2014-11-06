class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      #t.string :email
      t.string :first_name
      t.string :last_name
      t.string :genre
      t.string :profile_picture
      t.date :wedding_date
      t.integer :number_guests
      t.date :birth_date
      t.string :location
      t.string :relationship_status
      t.string :significant_other
      t.string :significant_other_id
      t.string :role
      t.string :cpf
      
      t.timestamps
    end
  end
end