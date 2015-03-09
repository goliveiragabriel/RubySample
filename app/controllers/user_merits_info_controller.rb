class UserMeritsInfoController < ApplicationController

  def update_closed
  	current_user.user_merits_info.closed = !current_user.user_merits_info.closed
  	current_user.user_merits_info.save
  	respond_to do |format|
  		format.html {redirect_to current_user}
  	end
  end
  
end
