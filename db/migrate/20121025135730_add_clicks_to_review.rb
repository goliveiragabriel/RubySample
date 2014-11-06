class AddClicksToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :number_of_iframe_clicks, :integer, :default => 0
    add_column :reviews, :number_of_home_clicks, :integer, :default => 0
  end
end
