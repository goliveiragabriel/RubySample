# encoding: utf-8
class SearchesController < AuthorizedController
  skip_before_filter :authenticate_user!
  skip_before_filter :set_search
  before_filter :points_notification
  layout "home", :only => :new
  
  def index
    @searches = @searches.where('user_id not in (?)', User.admin_ids)
    @searches_all = @searches.order("created_at DESC")
    @searches = @searches_all.page(params[:page]).per(50)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @searches }
      format.xls do
        render :xls => @searches_all,
                      :columns => [ :created_at, :service_type, :address, :name, :distance, :sort_by ],
                      :headers => %w[ Data Serviço Endereço Nome Distância Ordem ]
      end
    end
  end  
  
  def new
    @posts =  FeedEntry.order("published_at DESC").first(3)
    @last_reviews = Review.order("created_at DESC").limit(10)
    @likebox = false
    session[:sfilter] = nil
    session[:sid] = nil

    if Rails.env.production?
      fresh_when etag: [@last_reviews.maximum(:created_at), current_user], last_modified: @last_reviews.maximum(:created_at)
    end
    # expires_in 30.minutes

    #if cookies['_modalbox']
    #  @likebox = false
    #else
    #  @likebox = true
    #  cookies["_modalbox"] = {:value => true, :expires => 2.weeks.from_now.utc}
    #end
  end
  
  def create
    @search.attributes = {sort_by: "number_reviews DESC, rating_average DESC", distance: 75, price: "qualquer"}
    @search.service_type = nil if @search.service_type == "All"
    @search.search_source = "0" # para saber se o usuário clicou blog(2), icones home(1), na barra de busca home(0)
    if params[:service_menu_submit] == "1"
      #@search.address = user_city
      @search.search_source = "1"
    elsif params[:service_menu_submit] == "2"
      @search.search_source = "2"
    end
    @search.address = user_city
    @search.ip_address = request.remote_ip
    @search.user_id = (current_user ? current_user : 0)
    @search.save
    session[:sid] = @search.id
    redirect_to @search
  end
  
  def show
    @search.update_attributes(sort_by: "#{params[:c]} #{params[:t]}") if params[:c]
    @vendors = @search.vendors(session[:sfilter])
    @vendors_size = @vendors.size
    @vendors = @vendors.page(params[:page]).per(10)
    session[:spage] = params[:page]

    redirect_to(root_url, notice: 'Endereço não identificado') and return if get_markers == -1

    if Rails.env.production?
      fresh_when etag: [@search, current_user]
    end
    #expires_in 30.minutes
    
  end

  def edit

  end
  
  def update
    @search.assign_attributes(params[:search])
    @vendors = @search.vendors(params[:filter])
    @vendors_size = @vendors.size
    @vendors = @vendors.page(params[:page]).per(10)
    @search.save
    # Insere action se completou o Guia
    if current_user
      # Envia somente na primeira vez
      if current_user.user_merits_info.merits_actions.where(:action => MeritsAction::ACTIONS.keys[3]).size < 1
        alert = "Muito bom, você concluiu o nosso tutorial. Continue navegando pelo site e descubra mais novidades."
        current_user.add_merits_actions(alert, MeritsAction::ACTIONS.keys[3])
      end
    end
    session[:sfilter] = params[:filter]
    
    redirect_to(root_url, notice: 'Endereço não identificado') and return if get_markers == -1
    
    respond_to do |format|
      format.html { render action: "show" }
      format.json { head :ok }
    end
  end
  
  def delete_old_searches
    date = Time.parse(params[:date])
    Search.delete_all ["created_at < ?", date]

    respond_to do |format|
      format.html { redirect_to '/busca', only_path: true, notice: "Buscas antigas mais antigas que #{params[:date]} deletadas." }
    end
  end

  def blog
  end
  
end
