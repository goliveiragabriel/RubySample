class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.string :title
      t.text :summary
      t.text :content
      t.string :img_url
      t.string :url
      t.datetime :published_at
      t.string :guid

      t.timestamps
    end
  end
end
