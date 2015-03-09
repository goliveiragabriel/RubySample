class Hint < ActiveRecord::Base
	# has_and_belongs_to_many :merits
	has_many :merits, :through => :merits_hints	
	has_many :merits_hints, :dependent => :destroy
	# attr_accessible :content


end
