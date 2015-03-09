  # encoding: utf-8
# => Table: Users
#    t.string   "first_name"
#    t.string   "last_name"
#    t.string   "genre"
#    t.string   "profile_picture"
#    t.date     "wedding_date"
#    t.date     "birth_date"
#    t.string   "role"
#    t.datetime "created_at",                             :null => false
#    t.datetime "updated_at",                             :null => false
#   t.string   "email",                  :default => "", :null => false
#   t.string   "encrypted_password",     :default => "", :null => false #   t.string   "reset_password_token"
#   t.datetime "reset_password_sent_at"
#    t.datetime "remember_created_at"
#    t.integer  "sign_in_count",          :default => 0
#    t.datetime "current_sign_in_at"
#    t.datetime "last_sign_in_at"
#    t.string   "current_sign_in_ip"
#    t.string   "last_sign_in_ip"
#    t.string   "confirmation_token"
#    t.datetime "confirmed_at"
#    t.datetime "confirmation_sent_at"
#    t.string   "unconfirmed_email"
#    t.string   "location"
#    t.string   "relationship_status"
#    t.string   "significant_other"
#    t.string   "significant_other_id"
#    t.integer  "number_guests"
#    t.string   "cpf"
#    t.string   "telephone"
#
class User < ActiveRecord::Base
  # has_merit

  ajaxful_rater
  usar_como_cpf :cpf
  has_many :authentications, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :bookmarks, :dependent => :destroy
  has_many :vendors, :through => :bookmarks, :source => :bookmarkable, :source_type => 'Vendor', :uniq => true
  has_many :dresses, :through => :bookmarks, :source => :bookmarkable, :source_type => 'Dress', :uniq => true
  has_many :quotations, :dependent => :destroy
  has_many :tracks, :dependent => :destroy
  has_many :searches
  has_many :appointments, :dependent => :destroy
  has_many :track_dresses, :dependent => :destroy
  belongs_to :referrer, :class_name => "User"
  has_one :user_merits_info, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable, :timeoutable, :confirmable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  mount_uploader :profile_picture, PictureUploader
                  
  before_create :set_user_role
  after_create :send_welcome_email

#  attr_accessible :points
#  attr_accessible :first_name, :last_name, :remember_me, :genre, :profile_picture, :remote_profile_picture_url, :birth_date, :wedding_date, :significant_other,
#                  :number_guests, :relationship_status, :relationship_status, :cpf, :email, :password, :password_confirmation, :profile_picture, :telephone  
  validates_presence_of :first_name, :last_name, :email, :genre, :birth_date, :wedding_date, :relationship_status
  #validates_uniqueness_of :cpf
 
  ROLES = [
    ["Administrador", "admin"],
    ["Usuário", "user"]
  ]
  
  GENRES = [
    ["Masculino", "male"],
    ["Feminino", "female"]
  ]
  
  RELANTIONSHIP = [
    ["Solteira(o)", "Single"],
    ["Noiva(o)", "Engaged"],
    ["Casada(o)", "Married"],
    ["Profissional de casamento", "Industry professional"],
  ]

  def self.admin_ids
    where(role: "admin").collect(&:id)
  end
                   
  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    self.first_name = omniauth['info']['first_name'] if first_name.blank?
    self.last_name = omniauth['info']['last_name'] if last_name.blank?
    self.genre = omniauth['extra']['raw_info']['gender'] if genre.blank?
    self.remote_profile_picture_url = omniauth['info']['image'].split("?")[0]+"?type=large" if profile_picture.blank?
    birthday = omniauth['extra']['raw_info']['birthday']
    self.birth_date = Date.strptime(birthday, "%m/%d/%Y").strftime("%d/%m/%Y") if birth_date.blank?
    self.location = omniauth['info']['location']
    if omniauth['extra']['raw_info']['relationship_status']
      apply_relationship_status(omniauth['extra']['raw_info']['relationship_status'])
    end
    if omniauth['extra']['raw_info']['significant_other']
      self.significant_other = omniauth['extra']['raw_info']['significant_other']['name'] 
      self.significant_other_id = omniauth['extra']['raw_info']['significant_other']['id']
    end
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'])
  end
  
  def apply_relationship_status(relationship_status)
    relationship1 = %w[Engaged Married Single]
    relationship2 = ["In a relationship", "It's complicated", "In a open relationship", "Widowed", "Separated", "Divorced"]
    if relationship1.include?(relationship_status)
      self.relationship_status = relationship_status
    elsif relationship2.include?(relationship_status)
      self.relationship_status = "Single"
    else
      self.relationship_status = "Industry professional"
    end
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def set_user_role
    self.role = "user"
  end
  
  def admin?
    role == "admin"
  end

  def role?(role)
    self.role == role.to_s
  end
  
  def average_rating(object)
    rates = Rate.where('rateable_id = ? AND rater_id = ?', object.id, id)
    stars = rates.collect(&:stars)
    stars.size > 0 ? total = 0.0 + (eval stars.join("+")) : total = 0.0
    #mean = total/stars.size
    mean = total/4
    mean.round(1)
  end
  
  def to_param
    "#{id} #{first_name.downcase}".parameterize
  end
  
  def email_signature
    "#{first_name} #{last_name} <#{email}>"
  end
  
  def male?
    genre == "male"
  end
  
  def female?
    genre == "female"
  end
  
  def reviewed? (vendor)
    review = Review.where(:user_id => id, :vendor_id => vendor.id)
    review.size > 0 ? true : false
  end

  def bookmarked? (item)
    send(item.class.to_s.tableize).include?(item)
  end

  def find_bookmark(item)
    item_class = item.class.to_s == "Dress" ? "Dress" : "Vendor"
    bookmarks.where{(bookmarkable_id == item.id) & (bookmarkable_type == item_class)}.to_a
  end
  
  def name
    [first_name, last_name].join(' ')
  end

  def picture(size)
    "#{profile_picture}?type=#{size}"
  end

  def quotations_limit_reached?
    quotations.where(:created_at => DateTime.now.beginning_of_day..Time.now).size  > 10
  end

  def formated_data
    wedding_date.strftime("%B, %d %Y")
  end

  def days_to_go
    (wedding_date - DateTime.now).to_i > 0 ?  (wedding_date - DateTime.now).to_i : 0
  end

  def welcome_message
    w = male? ? "vindo" : "vinda"
    "Bem #{w} #{first_name} !"
  end

  def absolute_path_picture
    if profile_picture.url.to_s.eql?(profile_picture.default_url.to_s)
      profile_picture.default_url
    else
      profile_picture_url(:normal).to_s
    end
  end

  def set_referrer(rid)
    referrer = User.find(rid)
    self.referrer = referrer
    # pontuar referrer aqui
    referrer.add_merits_actions(name, MeritsAction::ACTIONS.keys[1])
    #player = referrer.user_merits_info 
    #merits_action = MeritsAction.new
    #merits_action.score = MeritsAction::ACTIONS.values[1]
    #merits_action.action = MeritsAction::ACTIONS.keys[1]
    #merits_action.user_merits_info_id = player.id
    #player.points += merits_action.score
    #merits_action.save
    #player.save
  end

  def add_merits_actions(alert, action)
    player = user_merits_info 

    merits_action = MeritsAction.new
    merits_action.score = MeritsAction::ACTIONS[action]
    merits_action.action = action
    merits_action.description = alert
    merits_action.user_merits_info_id = player.id
    player.points += merits_action.score
    #current_achievement = player.achievements.where("status = ?", Achievement::STATUS[1]).first
    # Achievement completed
    #if current_achievement.action_type == action
    #  current_achievement.status = Achievement::STATUS[2]
      # Configura o proximo achievement
    #  current_achievement.child.update_attributes(:status => Achievement::STATUS[1]) if current_achievement.child
    #  current_achievement.save!
    # end
    merits_action.save!
    player.save!
  end

  def set_default_user_merits
    @user_merits_info = UserMeritsInfo.new
    @user_merits_info.user_id = id
    @user_merits_info.points = 0
    @user_merits_info.closed = false

    if wedding_date && wedding_date < Date.today
      merits = Merit.where("merits_type = ?", "Newlywed")        
      @user_merits_info.merit_id = merits.first.id
    else
      merits = Merit.where("merits_type = ?", "Planning")        
      @user_merits_info.merit_id = merits.first.id
    end
    @user_merits_info.save
    # Set user achievements
    # @user_merits_info.set_achievements
  end

  def public_reviews
    reviews.where(anonymous: false)
  end

  def facebook
    fb_token = authentications.where(provider: "facebook").first.token
    @facebook ||= Koala::Facebook::API.new(fb_token)
    block_given? ? yield(@facebook) : @facebook
    rescue Koala::Facebook::APIError => e
      logger.info e.to_s
      nil
  end

  def friends
    @friends ||= facebook { |fb| fb.get_connections('me','friends',:fields=>"name,relationship_status,significant_other,installed") }
  end

  def engaged_friends
    if @engaged_friends
      return @engaged_friends
    else
      @engaged_friends = []
      friends.each do |f|
        @engaged_friends << f if (f.has_value?("Engaged") || f.has_value?("Married")) && !f.has_key?("installed")
      end
      return @engaged_friends
    end
  end

  private

  def send_welcome_email
    UserMailer.welcome_message(self).deliver
  end


end
