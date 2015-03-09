class TrackDetail < ActiveRecord::Base
  attr_accessible :track_id, :url
  belongs_to :track
end
