class TrackDress < ActiveRecord::Base
  # attr_accessible :dress_id, :user_id
  belongs_to :user
  belongs_to :dress

end
