class Merit < ActiveRecord::Base
  has_many :hints, :through => :merits_hints
  has_many :merits_hints, :dependent => :destroy
  attr_accessible :max_score, :merits_type
  has_many :user_merits_infos, :dependent => :destroy

  MAXSCORE = {"Newlywed" => 300, "Planning" => 200}
end

