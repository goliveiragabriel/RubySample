class Photo < ActiveRecord::Base
  belongs_to :vendor
  mount_uploader :image, ImageUploader
  
	attr_accessor :erase

  attr_accessible :image, :cover, :name, :erase

  def cover?
    cover
  end

  def self.bulk_update(photos)
    errors = {}
    photos.each do |photo_id,photo_attrs|
      photo = Photo.find(photo_id)
      if photo_attrs[:erase] == "1"
      	photo.destroy
      else
	      unless photo.update_attributes(photo_attrs)
	        errors[photo_id] = photo.errors
	      end
	    end
    end
    errors
  end
    
end