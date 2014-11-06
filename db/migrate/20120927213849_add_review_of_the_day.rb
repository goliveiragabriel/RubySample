class AddReviewOfTheDay < ActiveRecord::Migration
  def change
  	add_column :reviews, :review_of_the_day, :date
  end
end
