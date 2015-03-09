# encoding: utf-8
class ApplicationController < ActionController::Base
  require "ipaddr"
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => "Você não tem permissão para acessar essa página" #exception.message
  end
  before_filter :user_city
  before_filter :set_search
  helper_method :vendor_seo_path
  
  def vendor_seo_path(vendor)
    fornecedores_path(service: vendor.translated_type, 
                      city: vendor.city.parameterize, 
                      id: vendor)
  end

  def record_track_dress(dress_id)
    if current_user
      unless current_user.admin?      
        @track_dress = TrackDress.create(user_id: current_user.id, dress_id: dress_id)
      end
    end
  end
  
  def record_track(vendor_id, action)
    if !request.remote_ip.empty? && request.remote_ip != "unknown" 
      ip = request.remote_ip 
      # Filtrar GBot e BingBot
      # GBot Net Range - 66.249.64.0 ~ 66.249.95.255
      # BingBot Net Range - 131.253.21.0 ~ 131.253.47.255
      lowGBOT = IPAddr.new("66.249.64.0").to_i
      highGBOT = IPAddr.new("66.249.95.255").to_i
      lowBingBOT = IPAddr.new("131.253.21.0").to_i
      highBingBOT = IPAddr.new("131.253.47.255").to_i
      gadBOT = IPAddr.new("72.14.199.23").to_i
      toIP = IPAddr.new(ip).to_i
      # Filtros dos Bots
      if ( (lowGBOT..highGBOT)=== toIP || (lowBingBOT..highBingBOT)=== toIP || gadBOT===toIP) 
        return false
      end    
    else
      ip = "desconhecido"
    end
    if !current_user
      user_id = 0
      if (action == "entry")
        vendor_entry = Vendor.find(vendor_id)
        @track = Track.create( vendor_id: vendor_entry.id, user_id: user_id, ip: ip, action: action )
      else
        @track = Track.create( vendor_id: vendor_id, user_id: user_id, ip: ip, action: action )
      end
      # Toda Exit gera uma Entry
      if action == "exit"
        TrackDetail.create( track_id: @track.id, url: @vendor.name )
        Track.create( vendor_id: @vendor.id, user_id: user_id, ip: ip, action: "entry")
      end
   elsif !current_user.admin?
      user_id = current_user.id
      if (action == "entry")
        vendor_entry = Vendor.find(vendor_id)
        @track = Track.create( vendor_id: vendor_entry.id, user_id: user_id, ip: ip, action: action )
      else
        @track = Track.create( vendor_id: vendor_id, user_id: user_id, ip: ip, action: action )
      end
      # Toda Exit gera uma Entry
      if action == "exit"
        TrackDetail.create( track_id: @track.id, url: @vendor.name )
        Track.create( vendor_id: @vendor.id, user_id: user_id, ip: ip, action: "entry")
      end
    end
    # if (action == "entry")
    #   vendor_entry = Vendor.find(vendor_id)
    #   @track = Track.create( vendor_id: vendor_entry.id, user_id: user_id, ip: ip, action: action )
    # else
    #   @track = Track.create( vendor_id: vendor_id, user_id: user_id, ip: ip, action: action )
    # end
    # # Toda Exit gera uma Entry
    # if action == "exit"
    #   TrackDetail.create( track_id: @track.id, url: @vendor.name )
    #   Track.create( vendor_id: @vendor.id, user_id: user_id, ip: ip, action: "entry")
    # end
  end

  def set_guest_track(type, vendor_id)
    if type == 'quotation'
      record_track(vendor_id,"quotation")
    elsif type == 'review'
      vendor = Vendor.find(vendor_id)
      record_track(vendor.id, "review")
    elsif type == 'message'
      record_track(vendor_id,"message")
    end
  end


  # def save_merits_actions(action, target)
  #   player = current_user.user_merits_info 
  #   merits_action = MeritsAction.new
  #   merits_action.score = MeritsAction::ACTIONS[action]
  #   merits_action.action = action
  #   merits_action.target = target
  #   merits_action.user_merits_info_id = player.id
  #   player.points += merits_action.score
  #   merits_action.save
  #   player.save
  # end
  def set_search
    @search ||= Search.new
  end

  protected
  
  def after_sign_in_path_for(resource)
    return request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end
  
  def user_city
    if session[:user_city].nil?
      begin
        city = request.location.city
      rescue Exception => exc
        logger.info "IP geocoding service failed: #{exc}"
        city = "São Paulo, SP"
      end
      session[:user_city] = city.empty? ? "São Paulo, SP" : city
    end
    return session[:user_city]
  end

  
  def geocoded_search_address
    begin
      location = Address.new(street: @search.address).geocode
      #brazil = [[-35.00000,-80.00000], [6.00000,-30.00000]]
      #location = Geocoder.search(@search.address, bounds: brazil, params: {region: "br"})
      #location = Geocoder.search(@search.address)
    rescue Exception => exc
      logger.info "Address geocoding service failed: #{exc}"
      @search.address = nil
      location = nil
    end
    return location
  end

  def get_markers
    @markers = []
    if @search.address?
      location = geocoded_search_address
      if location.nil? || location.empty?
        return -1
      elsif !location.empty?
        marker_location = {lat: location[0], lng: location[1], description: @search.address, 
                           link: "query", link_text: "<img src='/images/flag.png' />",
                           picture: "/assets/flag.png", width: 20, height: 34}
        @markers << marker_location
        #@vendors = @vendors.order("distance ASC")
      end
    end
    @vendors.each_with_index do |v, i|
      v.gmaps_marker(i, @markers)
    end
    @markers = @markers.to_json
  end

  def points_notification
    if current_user && current_user.admin?
      @merits_actions = current_user.user_merits_info.merits_actions.where(notified: false)
      # @merits_actions = MeritsAction.where("user_merits_info_id = ? AND notified = ?", current_user.user_merits_info.id, false)
      subtotal = 0
      alert = ""
      action_points = Hash.new 
      review = false
      indicacao = false
      token = false
      guia = false
      #Inicializacao do hash
      MeritsAction::ACTIONS.each_key do |key|
        action_points[key] = 0
      end 
      
      if @merits_actions.size > 0

        @merits_actions.each do |merits_action|
          subtotal += merits_action.score
          merits_action.notified = true
          if merits_action.action.eql?(MeritsAction::ACTIONS.keys[0])
            review = true
            alert = merits_action.description
          elsif merits_action.action.eql?(MeritsAction::ACTIONS.keys[1])
            action_points["indicacao"] += 1
            alert = merits_action.description
            indicacao = true
          elsif merits_action.action.eql?(MeritsAction::ACTIONS.keys[2])
            token = true
            alert = merits_action.description
          elsif merits_action.action.eql?(MeritsAction::ACTIONS.keys[3])
            guia = true
          end
          merits_action.save
        end

        respond_to do |format|
          if subtotal > 0
            if review
              session[:gamification] = "#{alert} Mais #{subtotal} pontos para você."
            elsif indicacao
              if action_points["indicacao"] == 1
                session[:gamification] = "Parabéns. A sua amiga #{alert} se cadastrou no site e você ganhou #{subtotal} pontos."
              else
                session[:gamification] = "Parabéns, #{action_points['indicacao']} amigos se cadastraram e você ganhou #{subtotal} pontos."
              end
            elsif token
              session[:gamification] = "#{alert} #{subtotal} pontos!"
            elsif guia
              session[:gamification] = "Parabéns, você acabou de utilizar um de nossos filtros e por isso ganhou #{subtotal} pontos. Ganhe mais pontos convidando amigos para o site ou avaliando seus fornecedores."
            end
          end
          cookies['tipsy'] = {:value => '0', :expires => 30.days.from_now, :path => '/' }
          format.html {nil}
        end

      end
    end
  end

end
