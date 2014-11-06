namespace :db do
  task :select_review_of_the_day => :environment do
  	review = Review.joins(:vendor).where("vendors.active" => true).where("reviews.review_of_the_day IS NULL").random_ordem.readonly(false).first
  	review ||= Review.joins(:vendor).where("vendors.active" => true).order("reviews.review_of_the_day ASC").readonly(false).first
  	review.review_of_the_day = Date.today + 1
  	review.save
  end
end