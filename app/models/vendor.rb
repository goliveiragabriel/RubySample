# encoding: utf-8
class Vendor < ActiveRecord::Base
  has_many :reviews, :dependent => :destroy
  has_many :photos, :dependent => :destroy, :order => 'cover DESC'
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :users, :through => :bookmarks, :uniq => true
  has_many :quotations, :dependent => :destroy
  has_many :tracks, :dependent => :destroy
  has_many :dresses, :dependent => :destroy
  has_many :addresses, :dependent => :destroy
  has_one :proposal, :dependent => :destroy
  accepts_nested_attributes_for :addresses

  include FlagShihTzu
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]
  ajaxful_rateable stars: 5, dimensions: [:quality, :professionalism, :price, :flexibility], allow_update: true
  
  before_save :calculate_rating_average
  
  #attr_accessible :type, :off_listing_reason, :description, :name, :website, :email, :discount, :discount_title, :discount_description, :featured, :active, :price, :addresses_attributes
  validates_uniqueness_of :name
  validates_exclusion_of :slug, :in => %w(new edit index show data), :message => "is reserved. Please choose something else"
  validates_presence_of :type
  validates :discount_title, :length => { :maximum => 24}

  paginates_per 20 

  SERVICE_TYPES_LIST = [
    ["Alianças & Jóias", "Jewelry"],
    ["Assessora", "Planner"],
    ["Beleza & Saúde", "Beauty"],
    ["Bolos & Doces", "Cake"],
    ["Convite de Casamento", "Invitation"],
    ["Decoração", "Decoration"],
    ["Espaço para Eventos", "Venue"],
    ["Fotografia & Video", "Photography"],
    ["Gastronomia", "Catering"],
    ["Igrejas", "Church"],
    ["Lembranças", "Gift"],
    ["Lista de Presentes", "Registry"],
    ["Musica", "Band"],
    ["Outros Serviços", "Other"],
    ["Vestidos & Trajes", "Garment"],
    ["Viagem de Lua de Mel", "Travel"]
  ]

  ADVERTISING_PACKAGE_LIST = [
    ["Básico", "0"],
    ["Destaque", "1"],
    ["Destaque Pro", "2"]
  ]

  def self.filter_by_capacity(limits)
    minmax = limits.split("-")
    where{(details_field3 >= minmax[0]) & (details_field3 <= minmax[1])}
  end
    
  def address
    if addresses.size > 1
      "Vários endereços disponíveis"
    else
      address = addresses.first
      [address.street, address.city, address.state].compact.delete_if{|e| e.empty?}.join(', ')
    end
  end

  def richsnippets_address
    address = addresses.first
    fields = [["street-address", address.street], ["locality", address.city], ["region", address.state]]
    richsnippets = []
    fields.each do |field|
      richsnippets << "<span property='v:#{field[0]}'>#{field[1]}</span>" unless field[1].empty?
    end
    richsnippets.join(', ')
  end

  def city
    addresses.first.city || addresses.first.state
  end

  def phone
    addresses.first.phone1
  end

  def phones
    address = addresses.first
    phones = [address.phone1, address.phone2].compact
    phones.delete("")
    phones.join(' | ')
  end
  
  def cover_photo
    if photos.size > 0
      cover = photos.collect {|p| p if p.cover? }
      cover.compact!
      cover.empty? ? photos.first.image_url(:thumb) : cover.first.image_url(:thumb)
    else
      "no-image.png"
    end
  end

  def gmaps_picture(index)
    featured > 0 ? "/assets/feat-pin/feat-pin#{index}.png" : "/assets/pin/pin#{index}.png"
  end
 
  def gmaps_marker(index, markers)
    addresses.each do |address|
      markers << {lat: address.latitude, lng: address.longitude, description: address.gmaps_infowindow, 
                  title: name, sidebar: name, picture: gmaps_picture(index+1),
                  width: 25, height: 35, link: id}
    end
  end
  
  def title
    if reviews.size > 0 
      "Dicas de noivas sobre #{name}"
    elsif photos.size > 0
      "Fotos de #{name}"
    else
      name
    end
  end

  def check_for_lost_rates
    vid = self.id
    if number_reviews == 0
      rates = Rate.where{(rateable_id == vid) & (created_at < 1.hour.ago)}
      rates.destroy_all if rates.size > 0
    end
  end

  def translated_type
    I18n.t("#{type}").parameterize
  end

  def self.search(search)
    search ? where('name LIKE ?', "%#{search}%") : scoped
  end

  def email?
    email.blank? ? email2.blank? ? false : true : true
  end

  def destaque?
    featured == 1
  end

  def pro?
    featured == 2
  end

  private
  
  def calculate_rating_average
    rating_average = 0.0
    dimensions = %w{quality professionalism price flexibility}
    dimensions.each do |dimension|
      rating_average += self.send("rating_average_#{dimension}")
    end
    self.rating_average = rating_average / dimensions.size
    self.number_reviews = reviews.size
  end
  
end