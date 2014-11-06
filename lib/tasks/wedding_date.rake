namespace :db do
  task :update_wedding_date => :environment do
  	review = Review.all.each do |review|
	    user = review.user
	    user.wedding_date ||= review.date
	    user.save
  	end
  end
end