task :send_newsletter => :environment do
	# Criterios: ter email, não estar oculto e ter rating > 3
	vendors = Vendor.where("email != '' AND mailing = ? AND active = ? AND ( rating_average < ? OR rating_average >= ? ) AND type != ? ", true, true, 1, 3, Vendor::SERVICE_TYPES_LIST[12][1])
	vendors.each do |vendor|
	  UserMailer.newsletter(vendor).deliver
	end
end