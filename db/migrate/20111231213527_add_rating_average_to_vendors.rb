class AddRatingAverageToVendors < ActiveRecord::Migration
  def self.up
    add_column :vendors, :rating_average_quality, :decimal, :default => 0, :precision => 6, :scale => 2
    add_column :vendors, :rating_average_professionalism, :decimal, :default => 0, :precision => 6, :scale => 2
    add_column :vendors, :rating_average_price, :decimal, :default => 0, :precision => 6, :scale => 2
    add_column :vendors, :rating_average_flexibility, :decimal, :default => 0, :precision => 6, :scale => 2
    add_column :vendors, :rating_average, :decimal, :default => 0, :precision => 6, :scale => 2
    add_column :vendors, :number_reviews, :integer, :default => 0
  end

  def self.down
    remove_column :vendors, :rating_average_quality
    remove_column :vendors, :rating_average_professionalism
    remove_column :vendors, :rating_average_price
    remove_column :vendors, :rating_average_flexibility
    remove_column :vendors, :rating_average
    remove_column :vendors, :number_reviews
  end
end