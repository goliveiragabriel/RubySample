# => TABLE: quotations
#
#    t.integer  "user_id"
#    t.string   "comments"
#    t.integer  "vendor_id"
#    t.string   "telephone"
#    t.integer  "number_guests"
#    t.date     "wedding_date"
#    t.datetime "created_at",                              :null => false
#    t.datetime "updated_at",                              :null => false
#    t.string   "status",        :default => "Aguardando"
#    t.date     "sent_at"
#    t.string   "email",         :default => "",           :null => false
#
class Quotation < ActiveRecord::Base
  # attr_accessible :comments, :number_guests, :telephone, :vendor_id, :wedding_date, :status, :email

  belongs_to :user
  belongs_to :vendor

  validates_presence_of :telephone, :email, :wedding_date, :number_guests
  paginates_per 10

  QUOTATION_STATUS_LIST = [
  	["Aguardando","Aguardando"],
  	["Enviado","Enviado"]
   ]
end
