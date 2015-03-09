#encoding: utf-8
class QuotationsController < AuthorizedController
  layout "devise", :except => [:index, :quotations, :show]
  helper_method :sort_column, :sort_direction
  prepend_before_filter(:only => :new) { |controller| controller.set_guest_track('quotation',params[:vid])}

  # GET /quotations
  # GET /quotations.json
  # GET /quotations/quotations
  def index
    if params[:vid]
      @vendor = Vendor.find_by_slug(params[:vid])
      @quotations = @vendor.quotations
    end
    @quotations = @quotations.order("status", sort_column + " " + sort_direction).page params[:page]
    

    respond_to do |format|
      format.html  # index.html.erb
      format.json { render json: @quotations }
    end
  end

  # GET /quotations/1
  # GET /quotations/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @quotation }
    end
  end

  # GET /quotations/new
  # GET /quotations/new.json
  def new
    @quotation.vendor = Vendor.find(params[:vid])
    @quotation.email = current_user.email
    record_track(@quotation.vendor.id, "quotation")
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @quotation }
    end
  end

  # GET /quotations/1/edit
  def edit

  end

  # POST /quotations
  # POST /quotations.json
  def create
    vendor = @quotation.vendor
    @quotation.user = current_user

    respond_to do |format|
      unless current_user.quotations_limit_reached?
        # Altera o telefone, data de casamento e numero de convidados, somente quando o usuário não tem os atributos.
        current_user.telephone ||= @quotation.telephone
        current_user.wedding_date ||= @quotation.wedding_date
        current_user.number_guests ||= @quotation.number_guests
        current_user.save

        if @quotation.save
          UserMailer.quotation_created(@quotation).deliver
          UserMailer.user_proposal(current_user, @quotation).deliver
          format.html { redirect_to vendor_seo_path(vendor), notice: 'O seu orçamento foi registrado com sucesso.' }
          format.json { render json: @quotation, status: :created, location: @quotation }
        else
          format.html { redirect_to new_quotation_path(:vendor_id => vendor.id) }
          format.json { render json: @quotation.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to vendor_seo_path(vendor), alert: 'Você atingiu o limite diário de orçamentos.' }
      end
    end
  end

  # PUT /quotations/1
  # PUT /quotations/1.json
  def update

    respond_to do |format|
      if @quotation.update_attributes(params[:quotation])
        format.html { redirect_to orcamentos_path(@quotation.vendor), notice: 'O orçamento foi atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotations/1
  # DELETE /quotations/1.json
  def destroy
    vendor = @quotation.vendor
    @quotation.destroy

    respond_to do |format|
      flash[:notice] = "Orçamento excluído com sucesso."
      format.html { redirect_to orcamentos_path(vendor) }
      format.json { head :no_content }
    end
  end

  def send_email
    if !@quotation.status.eql? "Enviado"
      @quotation.status = "Enviado"
      @quotation.sent_at = Time.now
      respond_to do |format|
        if @quotation.save!
          UserMailer.quotation_submitted(@quotation).deliver
          format.html { redirect_to orcamentos_path(@quotation.vendor), notice: "Orçamento enviado com sucesso." }
        end
      end   
    else
      respond_to do |format|
        flash[:alert] = "Erro: O seu orçamento já foi enviado."
        format.html { redirect_to orcamentos_path(@quotation.vendor)}
      end
    end
  end

  
  private
  
  def sort_column
    Quotation.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
