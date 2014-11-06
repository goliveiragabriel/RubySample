desc "Remove searches created by admins"
namespace :db do
  task :remove_admin_searches => :environment do
  	admins = User.where(role: "admin")
    admins.each do |admin|
    	Search.delete_all ["user_id = ?", admin.id]
    end
  end
end