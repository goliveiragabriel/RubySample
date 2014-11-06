namespace :db do
  task :copy_email => :environment do
  	Vendor.all.each do |v|
      v.email2 = v.email
  		v.save
    end
  end
end