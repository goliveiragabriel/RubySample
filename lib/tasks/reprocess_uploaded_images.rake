desc "Reprocess Uploaded Images"
namespace :db do
  task :reprocess_uploaded_images => :environment do
  	vendors = Vendor.where{(id > 2) & (id < 48)}
		vendors.each do |vendor|
		  vendor.photos.each do |photo|
		  	photo.image.recreate_versions!
		  end
		end
	end
end