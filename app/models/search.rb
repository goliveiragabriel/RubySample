class Search < ActiveRecord::Base
  belongs_to :user
  attr_accessible :sort_by, :distance, :price, :service_type, :address, :name
  before_update :sum_filter

  def sum_filter
    self.filter += 1
  end
  
  def vendors(params={})
    begin
      @vendors ||= find_vendors(params)
    rescue Exception => exc
      logger.info "Address geocoding service failed: #{exc}"
      self.address = nil
      @vendors = find_vendors(params)
    end
  end

  def to_param
    url = [id]
    url << translated_service_type.parameterize if service_type?
    url << address.parameterize if address?
    url << name.parameterize if name?
    url.join("&")
  end
  
  def title
    title = []
    title << translated_service_type if service_type?
    title << address if address?
    title << name if name?
    title.join(" - ")
  end
  
  def filtered?(params={})
    service_type? || address? || name? || !params.blank?
  end
  
  def translated_service_type
    I18n.t("#{service_type}") if service_type?
  end
  
  private
  
  def find_vendors(params)

    if service_type.present?
      service = service_type.constantize
      vendors = service.scoped
      if params
        v = service.new
        params.each_pair do |key, val|
          if key == "capacity"
            vendors = vendors.filter_by_capacity(val)
            self.filter_details2 = val
          else
            vendors = vendors.send(key)
            v.send("#{key}=",true)
            self.filter_details1 = v.send("#{service_type.downcase}_details")
          end
        end
      end
    else
      vendors = Vendor.scoped
    end
    
    vendors = vendors.where(active: true)
    vendors = vendors.where(price: price) if price.present? && price != "qualquer"
    if name.present?
      terms = name.split.collect!{|term| "%" + term + "%"}
      #vendors = vendors.where{name.like_all terms}
      vendors = vendors.where{(name.like_all terms) | (description.like_all terms)}
    end
    vendors = vendors.order("featured DESC")
    vendors = vendors.order(sort_by) if sort_by != "distance ASC"

    if address.present?
      brazil = [[-35.00000,-80.00000], [6.00000,-30.00000]]
      # Somente em production
      vendor_ids = Address.near(address, distance, bounds: brazil, params: {region: "br"}).collect{|a| a.vendor_id}.uniq.compact if Rails.env.production?
      if vendor_ids.size > 0
        vendors = vendors.where('id in (?)', vendor_ids)
        sort_by_distance = "FIELD(id, #{vendor_ids.to_s[1..vendor_ids.to_s.size-2]})"
        vendors = vendors.order(sort_by_distance) if Rails.env.production?
      else
        vendors = vendors.where(id: 0)
      end
    end
    
    vendors
  end
  
end
