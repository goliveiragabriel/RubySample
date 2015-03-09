	# Table name: tracks
 #    t.integer  "user_id"
 #    t.integer  "vendor_id"
 #    t.string   "ip"
 #    t.string   "action"
 #    t.datetime "created_at", :null => false
 #    t.datetime "updated_at", :null => false
class Track < ActiveRecord::Base
  attr_accessible :action, :id, :ip, :user_id, :vendor_id, :created_at

  belongs_to :user
  belongs_to :vendor
  has_one :track_detail, :dependent => :destroy

  paginates_per 20


  TRACK_ACTIONS_LIST = [
    "mapa",
    "website",
    "telefone",
    "review",
    "quotation",
    "exit",
    "entry",
    "ler_mais",
    "message",
    "proposal"
  ]

  def self.search(search, option)
    if search
      if option == "vendor"
        joins(:vendor).where('name LIKE ?', "%#{search}%")
      elsif option == "user"
        joins(:user).where('first_name LIKE ?', "%#{search}%")
      elsif option == "ip"      
        where('ip LIKE ? ', "%#{search}%")
      end
    else
      scoped
    end
  end

end
