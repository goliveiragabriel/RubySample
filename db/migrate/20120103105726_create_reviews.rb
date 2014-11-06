class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :vendor_id
      t.string :title
      t.text :content
      t.date :date
      t.string :reviewer_type
      t.boolean :recommendation
      t.boolean :anonymous
      t.string :anonymous_picture

      t.timestamps
    end
  end
end
