desc "Migrates vendor's address to the addresses table"
namespace :db do
  task :migrate_addresses => :environment do
  	Vendor.all.each do |v|
  		a = Address.new
  		a.street = v.addr_street
  		a.complement = v.addr_complement
  		a.city = v.addr_city
  		a.state = v.addr_state
  		a.zipcode = v.addr_zipcode
  		a.region = v.addr_region
  		a.latitude = v.latitude
  		a.longitude = v.longitude
  		a.phone1 = v.phone1
  		a.phone2 = v.phone2
  		v.addresses << a
  		v.save
    end
  end
end