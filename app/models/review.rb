# encoding: utf-8
class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :vendor

  attr_accessor :terms_of_service

  attr_accessible :vendor_id, :content, :recommendation, :title, :date, :anonymous, :anonymous_picture, :reviewer_type, :terms_of_service, :review_of_the_day, :number_of_home_clicks, :number_of_iframe_clicks
  
  validates_presence_of :vendor_id, :reviewer_type, :date, :title
  validate :has_rating, :on => :create
  validates_acceptance_of :terms_of_service, :message => '^Você deve aceitar o termo de serviço'
  
  REVIEWER_TYPE_LIST = [
    ["Noiva(o) e fechei contrato", "Noiva com contrato"],
    ["Noiva(o) mas não fechei contrato", "Noiva sem contrato"],
    ["Convidada(o)", "Convidada"],
    ["Profissional de casamento ", "Profissional"]
  ]

  def self.random_ordem
    Rails.env.production? ? order("RAND()") : order("RANDOM()")
  end

  def destroy
    Rate.destroy_all(:rater_id => user.id, :rateable_id => vendor.id)
    super
  end


  def noiva?
    (reviewer_type == "Noiva com contrato" || reviewer_type == "Noiva sem contrato") ? true : false
  end

  private
  
  def has_rating
    rates = Rate.where(:rater_id => user.id, :rateable_id => vendor.id)
    if rates.size < 4
      errors.add(:nota, "não pode ficar em branco")
    end
  end
  
end
