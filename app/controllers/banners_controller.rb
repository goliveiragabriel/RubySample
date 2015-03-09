# encoding: utf-8
class BannersController < ApplicationController
  layout "devise"
  # References http://narutosanjiv.wordpress.com/2012/05/08/rails-3-and-jsonp-cross-domain-with-ajax/
  # http://blog.carbonfive.com/2012/02/27/supporting-cross-domain-ajax-in-rails-using-jsonp-and-cors/
  before_filter :set_access_control_headers

  def index
  end

  def show
  	@vendor = Vendor.find(params[:vendor_id])
  	vendor= @vendor.to_json
		respond_to do |format|
			format.json{render :json => vendor, :callback => params[:callback]}
		end

  end

 def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "17600"
  end

end
