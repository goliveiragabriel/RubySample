class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :bookmarkable_id
      t.string  :bookmarkable_type
      t.integer :user_id
      t.text :comments

      t.timestamps
    end
  end
end
