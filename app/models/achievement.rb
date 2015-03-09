#encoding: utf-8
class Achievement < ActiveRecord::Base
  belongs_to :user_merits_info
  has_one :child, :class_name => "Achievement"
  belongs_to :child, :class_name => "Achievement", :foreign_key => 'child_id'
  attr_accessible :action_type, :child_id, :message, :name, :score, :status, :user_merits_info_id

  STATUS = ["unstarted", "inprogress", "completed"]

end
