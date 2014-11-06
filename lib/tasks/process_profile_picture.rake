desc "Saves the profile picture do Amazon/S3"
namespace :db do
  task :process_profile_picture => :environment do
  	User.all.each do |user|
  		if user.profile_picture?
  			init = 57 + user.id.to_s.length
    		user.remote_profile_picture_url = user.picture("large")[init..300]
    		user.save(:validate => false)
    	end
    end
  end
end