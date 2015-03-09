#encoding: utf-8
class Dress < ActiveRecord::Base 
  #attr_accessible :brand, :description, :featured, :name, :share, :vendor_id, :price
  #acts_as_taggable_on :sleeve, :skirt, :neckline, :silhouette, :strap, :fabric, :length
  has_many :appointments
  has_many :dress_photos, :dependent => :destroy, :order => 'cover DESC'
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :users, :through => :bookmarks, :uniq => true
  has_many :track_dresses, :dependent => :destroy
  belongs_to :vendor

  #validates_uniqueness_of :name

  SLEEVE = ["Curta", "3/4", "Longa", "Sem manga", "Com alcinha"]
  NECKLINE = ["Quadrado", "Coracao", "Canoa", "Frente unica", "V", "Arredondado", "Drapeado"]
  SILHOUETTE = ["Sereia","Evase", "Tubinho", "Romano", "Princesa", "Baile"]
  FABRIC = ["Tule", "Tafeta", "Seda", "Cetim", "Organza", "Renda", "Algodao", "Gaze", "Chiffon", "Brocado"]
  LENGTH = ["Longo", "Curto", "Longuete", "Saia removivel"]
  COLOR = ["Branco", "Off-white","Perola", "Champanhe", "Mais cores"]
  PRICE = ["1", "2", "3", "4", "5"]
  FINISH = ["Bordado","Liso", "Aplicacao","Plissado", "Drapeado", "Renda"]
  TRAIN = ["Longa", "Curta", "Media", "Sem cauda"]

  # Novo modelo: Com cauda => Longa,Curta,Media 
  # Lista Black Tie??

  # def select_randomly_by_price
  #   preco = joins(:favorites).where("user_id = ? ", current_user.id).select("count(price) as freq_price").group("price").order("freq_price DESC").first
  # end

  def self.random_ordem
    Rails.env.production? ? order("RAND()") : order("RANDOM()")
  end

  def cover_photo(size)
    if dress_photos.size > 0
      cover = dress_photos.collect {|p| p if p.cover? }
      cover.compact!
      cover.empty? ? dress_photos.first.image_url(size) : cover.first.image_url(size)
    else
      "no-image.png"
    end
  end
  
  def filtered?(params={})
    sleeve? || neckline? || silhouette? || fabric? || length? || color? || finish? || train? || price? || !params.blank?
  end

  def photos
    dress_photos
  end

  def price_to_dollar
    if price.eql?(1)
      "$"
    elsif price.eql?(2)
      "$$"
    elsif price.eql?(3)
      "$$$"
    elsif price.eql?(4)
      "$$$$"
    elsif price.eql?(5)
      "$$$$$"
    end
  end


end