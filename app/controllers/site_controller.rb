# encoding: utf-8
class SiteController < ApplicationController
  
  layout "iframe", :except => :about_us
  
  def about_us
  end

  # Review do dia iframe: <iframe src="http://localhost:3000/reviewoftheday" scrolling="no" width="310" frameborder="0" height="250></iframe>
  def reviewoftheday
    @review = Rails.env.development? ? Review.first : Review.where(review_of_the_day: Date.today).first
    if params[:number_of_clicks]
    	if params[:tipo] == "iframe"
    		@review.number_of_iframe_clicks += params[:number_of_clicks].to_i
	    	@review.save!
	    elsif params[:tipo] == "home"
	    	@review.number_of_home_clicks += params[:number_of_clicks].to_i
	    	@review.save!
    	end
    end

    expires_in 6.hours
    fresh_when @review

  end

  #Busca do Blog iframe: <iframe src="http://www.bemcasados.art.br/buscablog" scrolling="no" width="510" frameborder="0" height="120"></iframe>
  def search
    @search = Search.new

    expires_in 1.month
  end

end
