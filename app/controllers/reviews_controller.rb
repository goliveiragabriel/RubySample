# encoding: utf-8
class ReviewsController < AuthorizedController
  layout "devise", :except => :index
  prepend_before_filter(:only => :new){ |controller| controller.set_guest_track('review', params[:vid]) }
  
  # GET /reviews
  # GET /reviews.json
  def index
    @user = User.find(params[:uid])
    @reviews = @reviews.where(user_id: @user.id).where(anonymous: false)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviews }
    end
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show

    respond_to do |format|
      format.html #show
      format.json { render json: @review }
    end
  end

  # GET /reviews/new
  # GET /reviews/new.json
  def new
    @review.vendor = Vendor.find(params[:vid])
    record_track(@review.vendor.id, "review")
    if current_user.reviewed?(@review.vendor)
      return redirect_to(vendor_seo_path(@review.vendor), notice: 'Você já avaliou este fornecedor')
    end
    respond_to do |format|
      format.html
      format.json { render json: @review }
    end
  end

  # GET /reviews/1/edit
  def edit
    
  end

  # POST /reviews
  # POST /reviews.json
  def create
    vendor = @review.vendor
    @review.user = current_user
    current_user.wedding_date ||= @review.date
    
    respond_to do |format|
      if @review.save
        vendor.save
        current_user.save
        # Em teste para admin
        # if current_user.admin?
          alert = "Que legal, a sua avaliação com certeza ajudará outras noivas."
          current_user.add_merits_actions(alert,MeritsAction::ACTIONS.keys[0])
          # Concede pontos ao amigo que convidou
          if current_user.referrer_id
            user_referred = User.find(current_user.referrer_id)
            current_user.male? ? alert = "O seu amigo #{current_user.name} avaliou o fornecedor #{vendor.name} e por isso você ganhou" : alert = "A sua amiga #{current_user.name} avaliou o fornecedor #{vendor.name} e por isso você ganhou"
            user_referred.add_merits_actions(alert,MeritsAction::ACTIONS.keys[0])
          end
        # end

        UserMailer.review_submitted(@review).deliver
        format.html { redirect_to vendor_seo_path(vendor), notice: 'A sua avaliação foi registrada com sucesso' }
        format.json { render json: @review, status: :created, location: @review }
      else
        format.html { render action: "new" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reviews/1
  # PUT /reviews/1.json
  def update

    respond_to do |format|
      if @review.update_attributes(params[:review])
        format.html { redirect_to vendor_path(@review.vendor, view: "recomendacoes"), notice: 'A sua avaliação foi atualizada com sucesso' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    vendor = @review.vendor
    user = @review.user
    @review.destroy
    vendor.save # para atualizar o number_reviews

    respond_to do |format|
      format.html { redirect_to vendor_path(vendor, view: "recomendacoes") }
      format.json { head :ok }
    end
  end

  
end
