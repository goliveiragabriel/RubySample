class MeritsHint < ActiveRecord::Base
  belongs_to :merit 
  belongs_to :hint
  #attr_accessible :, :hint_id


end
