class Address < ActiveRecord::Base
  belongs_to :vendor

  acts_as_gmappable process_geocoding: false,  # geocoder is doing the forward and inverse geocoding
                    address: "address", normalized_address: "gmaps", check_process: :prevent_geocoding, 
                    msg: "Sorry, not even Google Maps could figure out where that is"
  geocoded_by :full_address
  reverse_geocoded_by :latitude, :longitude, :address => :gmaps

  after_validation :geocode #, :reverse_geocode

  attr_accessible :vendor_id, :name, :street, :complement, :district, :city, :state, :zipcode, :region, :phone1, :phone2

  def full_address
    [street, city, state].compact.delete_if{|e| e.empty?}.join(', ')
  end

  def gmaps_infowindow
    "#{vendor.name} <br /> #{full_address}"
  end

  private
  
  def prevent_geocoding
    full_address.blank? || (!latitude.blank? && !longitude.blank?) 
  end

end
