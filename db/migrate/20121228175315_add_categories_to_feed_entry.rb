class AddCategoriesToFeedEntry < ActiveRecord::Migration
  def up
  	add_column :feed_entries, :categories, :string
  end
  def down
  	remove_column :feed_entries, :categories
  end
end
