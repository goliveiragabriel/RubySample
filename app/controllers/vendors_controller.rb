# encoding: utf-8
class VendorsController < AuthorizedController
  skip_before_filter :authenticate_user!, :only => [:show, :mapa, :telefone, :site, :ler_mais]
  helper_method :sort_column, :sort_direction  
  before_filter :points_notification, :only => :show
  
  # GET /vendors
  # GET /vendors.json
  def index
    # Search and Order index.html
    @vendors = @vendors.search(params[:search])
    @vendors = @vendors.order(sort_column + " " + sort_direction).page params[:page]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vendors }
    end
  end

  # GET /vendors/1
  # GET /vendors/1.json
  def show
    raise ActionController::RoutingError.new("Fornecedor nao cadastrado") unless @vendor.active
    @vendor_badge = Hash.new
    @vendor_badge['discount'] = @vendor.discount ? 1 : 0
    @vendor_badge['proposal'] = @vendor.proposal ? 1 : 0
    if request.path != vendor_seo_path(@vendor)
      if params[:b]
        redirect_to fornecedores_path(service: @vendor.translated_type, city: @vendor.city.parameterize, id: @vendor, b: params[:b]), status: :moved_permanently
      else
        redirect_to vendor_seo_path(@vendor), status: :moved_permanently
      end
    end
    if session[:sid]
      @search = Search.find(session[:sid])
      if @search.service_type == @vendor.type
        @vendors_search = @search.vendors(session[:sfilter]).page(session[:spage])
      else
        session[:sid] = nil
        session[:sfilter] = nil
        @vendors_search = Vendor.where(type: @vendor.type).order("number_reviews DESC")
      end
    else
      @vendors_search = Vendor.where(type: @vendor.type).order("number_reviews DESC")
    end
    @vendors_search = @vendors_search.where('id not in (?)', @vendor.id).first(10)
    # Track não-administrativo
    if params[:vid]
      record_track(params[:vid], "exit")
    elsif (params[:id])
      record_track(params[:id],"entry")
    end
    @reviews = @vendor.reviews.order("date DESC").page(params[:page]).per(8)
    @vendor.check_for_lost_rates
    @service_type = @vendor.type
    @count_reviews = true

    # expires_in 30.minutes
    # fresh_when @vendor
  end

  # GET /vendors/new
  # GET /vendors/new.json
  def new
    address = @vendor.addresses.build(name: "Principal")

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vendor }
    end
  end

  # GET /vendors/1/edit
  def edit

  end

  # POST /vendors
  # POST /vendors.json
  def create
    @vendor.type = params[:service_type]
    
    respond_to do |format|
      if @vendor.save
        format.html { redirect_to "#{edit_vendor_path(@vendor)}#d", notice: 'Forneça mais detalhes sobre este fornecedor.' }
        format.json { render json: @vendor, status: :created, location: @vendor }
      else
        format.html { render action: "new" }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vendors/1
  # PUT /vendors/1.json
  def update
    service = @vendor.type.downcase
    @vendor.type = params[:service_type]

    respond_to do |format|
      if @vendor.update_attributes(params[service.to_sym])
          format.html { redirect_to vendor_photos_path(@vendor), notice: 'Adicione fotos para este fornecedor.' }
          format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.json
  def destroy
    @vendor.destroy

    respond_to do |format|
      format.html { redirect_to vendors_url }
      format.json { head :ok }
    end
  end
  
  def rate
    @vendor.rate(params[:stars], current_user, params[:dimension])

    respond_to do |format|
      format.js { render :partial => "rating", :locals => {:dimension => params[:dimension]} }
    end
  end
  
  def mapa
    @marker = @vendor.addresses.to_gmaps4rails

    record_track(@vendor.id, "mapa")
    respond_to do |format|
      format.html { render action: "mapa", layout: "devise" }
    end
  end

  def widget
    # 27/11/2012: 
    # 16 fornecedores com estas condições
    # 156 fornecedores com reviews
    # @vendors = Rails.env.production? ? Vendor.joins( :reviews ).where( "rating_average > ? AND reviews.created_at > ? AND reviews.created_at <= ? ",4, Date.today-6.months, Date.today ).group("vendors.id").order( "name ASC" ) : Vendor.order("name ASC")
    @vendors = Rails.env.production? ? Vendor.joins( :reviews ).where( "rating_average > ? ", 4).group("vendors.id").order( "name ASC" ) : Vendor.where("rating_average > ? ", 4).order("name ASC")
  end

  def telefone
    record_track(@vendor.id, "telefone")
    respond_to do |format|
      format.js
      format.html { redirect_to vendor_seo_path(@vendor) }
    end
  end

  def site
    record_track(@vendor.id, "website")
    redirect_to @vendor.website
  end

  def ler_mais
    record_track(@vendor.id, "ler_mais")
    render nothing: true 
  end


  def desc
    respond_to do |format|
      format.html { render action: "desc", layout: "devise" }
    end    
  end

  def send_newsletter
    # Criterios: ter email, não estar oculto e ter rating > 3
    # @vendors = Vendor.where("email != '' AND mailing = ? AND active = ? AND ( rating_average < ? OR rating_average >= ? ) AND type != ? ", true, true, 1, 3, Vendor::SERVICE_TYPES_LIST[12][1])
    @vendors = Vendor.first
    if (@vendors.reviews.size > 0)
      UserMailer.newsletter(@vendors).deliver
    end
    # @vendors.each do |vendor|
    #   if (vendor.reviews.size > 0)
    #     UserMailer.newsletter(vendor).deliver
    #   end
    # end
    respond_to do |format|
      format.html{redirect_to vendors_path, notice: 'Newsletters enviadas com sucesso.'}
    end
  end

  # Info: Serão enviados 99 emails 07/11/2012
  def vendor_reviews
    @vendors = Vendor.where("email2 != ''")
    # Devemos controlar as reviews enviadas. Sugiro por período, esta primeira newsletter enviamos todas, 
    # em seguida, marcamos a data de envio neste comentário 
    # e da próxima vez
    # seleciona-se por intervalo de created_at.
    # 
    # E-mail enviado em: XX/XX/XXXX
    @vendors = Vendor.first
    if (@vendors.reviews.size > 0)
      UserMailer.vendor_reviews(@vendors).deliver
    end
    # @vendors.each do |vendor|
    #   if (vendor.reviews.size > 0)
    #     UserMailer.newsletter(vendor).deliver
    #   end
    # end

    respond_to do |format|
      format.html{redirect_to vendors_path, notice: 'Reviews enviadas com sucesso.'}
    end
  end

  def user_request_proposal
    begin
      if current_user.mailing
        UserMailer.user_request_proposal(current_user, @vendor).deliver
        # Grava Track
        record_track(@vendor, Track::TRACK_ACTIONS_LIST[9])
        respond_to do |format|
          format.html{redirect_to vendor_path(@vendor), notice: 'O orçamento instantâneo foi enviado com sucesso.'}
        end
      else
        respond_to do |format|
          format.html{redirect_to vendor_path(@vendor), notice: 'Você cancelou a sua inscrição na Bem Casados. Para voltar a receber nossos email entre em contato conosco.'}
        end
      end
    rescue Exception => exc
      logger.info "User request proposal error."
    end
  end

  # def user_proposal
  #   begin
  #     if @vendor.email?
  #       UserMailer.user_proposal(current_user, @vendor).deliver
  #       record_track(@vendor, Track::TRACK_ACTIONS_LIST[9])
  #       respond_to do |format|
  #         format.html{redirect_to vendor_path(@vendor), notice: 'O seu pedido de orçamento foi enviado com sucesso.'}
  #       end
  #     else
  #       respond_to do |format|
  #         format.html{redirect_to vendor_path(@vendor), notice: 'O seu pedido não foi enviado com sucesso.'}
  #       end
  #     end
  #   rescue
  #     logger.info "User first request proposal error."
  #   end

  # end
  private
  
  def sort_column
    Vendor.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end