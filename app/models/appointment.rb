class Appointment < ActiveRecord::Base
  attr_accessible :data, :dress_id, :user_id, :vendor_id, :telephone
  belongs_to :dress
  belongs_to :user

  def formated_data
  	data.strftime("%d, %b %Y - %H:%M")
  end

end
