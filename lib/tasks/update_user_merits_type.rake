namespace :db do
  task :update_user_merits_type => :environment do
  	User.all.each do |user|
      unless user.wedding_date.nil? 
         user.user_merits_info.merit_id =  user.wedding_date <= Date.today ? Merit.where(merits_type: "Planning").first.id : Merit.where(merits_type: "Newlywed").first.id
      else
        user.user_merits_info.merit_id = Merit.where(merits_type: "Planning").first.id
      end
      user.user_merits.info.save
  	end
  end
end