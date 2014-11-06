desc "Migrates user's merits infos to the user merits info table"
namespace :db do
  task :migrate_user_info => :environment do
  	User.all.each do |v|
  		a = UserMeritsInfo.new
  		a.closed = false
      a.user_id = v.id
      a.points = 0
      unless v.wedding_date.nil? 
        v.wedding_date > Date.today ? a.merit_id = Merit.where("merits_type = ?", "Planning").first.id : a.merit_id = Merit.where("merits_type = ?", "Newlywed").first.id
      else
        a.merit_id = Merit.where("merits_type = ?", "Planning").first.id
      end
  		a.save
    end
  end
end