# encoding: utf-8
class UsersController < AuthorizedController
  layout "devise", only: [:edit, :create_invitation]
  skip_before_filter :authenticate_user!, :only => :accepted_invitation
  before_filter :points_notification

  def index
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
  
  def show
    @user = current_user
    @favourites_type = @user.bookmarks.select("bookmarks.id as bookmark_id, vendors.*, bookmarks.* ").where("bookmarkable_type = ?", "Vendor").joins("LEFT OUTER JOIN vendors ON vendors.id = bookmarks.bookmarkable_id").group_by { |t| t.type }
    @propostas_tipo = @user.quotations.select("quotations.created_at as data_criacao, quotations.*, vendors.*").joins("LEFT OUTER JOIN vendors ON vendors.id = quotations.vendor_id").group_by { |t| t.type }
    @posts = FeedEntry.where("categories is not null")
    posts_array = @posts.collect
    @feeds = Hash.new
    FeedEntry::FEEDS_CATEGORIES_RSS.each do |key, value|
      @feeds[key] = posts_array.find_all{ |post| post.categories.include?(value[0]) }
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end
  
  def edit
    
  end
  
  def create
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    
    respond_to do |format|
      if @user.update_attributes(params[:user], :as => :admin)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Vendor was successfully updated.' }
      format.json { head :ok }
    end
  end

  def send_tester_email
    UserMailer.tester_email(@user).deliver
    respond_to do |format|
      format.html { redirect_to users_path, notice: "Email enviado com sucesso." }
    end
  end

  def create_invitation
    if current_user.referral_token.nil?
      current_user.update_attribute(:referral_token, rand(36**16).to_s(36))  
      alert = "Parabéns, aguardamos o cadastro dos seus amigos. Para cada novo amigo cadastrado na Bem Casados através do seu convite você ganhará #{MeritsAction::ACTIONS.keys[1]} pontos. E para começar você acabou de ganhar"
      # ganha pontos por gerar url
      current_user.add_merits_actions(alert, MeritsAction::ACTIONS.keys[2])
    end
    @referral_url = "www.bemcasados.art.br/convite/#{current_user.referral_token}"
    @app_id = Rails.env.production? ? Yetting.facebook_app_id : Yetting.facebook_app_id2
  end

  def accepted_invitation
    referrer = User.find_by_referral_token(params[:token])
    cookies['referrer-id'] = referrer.id
    redirect_to new_user_registration_path
  end

  def unsubscribe
    current_user.mailing = false
    current_user.save
    respond_to do |format|
      format.html{redirect_to user_path(current_user), alert: "Inscrição cancelada com sucesso."}
    end
  end

end