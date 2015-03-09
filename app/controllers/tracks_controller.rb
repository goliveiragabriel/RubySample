  #========== Table name: tracks ===============
  #=============================================
  #   t.integer  "user_id"
  #   t.integer  "vendor_id"
  #   t.string   "ip"
  #   t.string   "action"
  #   t.datetime "created_at", :null => false
  #   t.datetime "updated_at", :null => false

class TracksController < AuthorizedController
  helper_method :sort_column, :sort_direction

  # GET /tracks
  # GET /tracks.json
  def index
    if(params[:vendor_id])
      @vendor = Vendor.find_by_slug(params[:vendor_id])
      @tracks = Track.where("vendor_id = ?", @vendor.id)
      @tracks = @tracks.order(sort_column + " " + sort_direction).page params[:page]
    elsif (params[:user_id])
      @user = User.find(params[:user_id])
      @tracks = Track.where("user_id = ?", @user.id)
      @tracks = @tracks.order(sort_column + " " + sort_direction).page params[:page]
      @tracks = @tracks.order("created_at desc")
    elsif (params[:ip])
      ip = params[:ip].gsub('-','.')
      @tracks = Track.where("ip LIKE ? ", "%#{ip}%")
      @tracks = @tracks.order(sort_column + " " + sort_direction).page params[:page]
      @tracks = @tracks.search(params[:search], params[:tipo])
      @tracks = @tracks.order("created_at desc")
    else
      # Método que busca por fornecedor quando exibir informaçao de todas
      @tracks = Track.order(sort_column + " " + sort_direction).page params[:page]
      @tracks = @tracks.search(params[:search], params[:tipo])
      @tracks = @tracks.order("created_at desc")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracks }
    end
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track }
    end
  end

  # GET /tracks/new
  # GET /tracks/new.json
  def new
    @track = Track.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @track }
    end
  end

  # GET /tracks/1/edit
  def edit
    @track = Track.find(params[:id])
  end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = Track.new(params[:track])

    respond_to do |format|
      if @track.save
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render json: @track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tracks/1
  # PUT /tracks/1.json
  def update
    @track = Track.find(params[:id])

    respond_to do |format|
      if @track.update_attributes(params[:track])
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track = Track.find(params[:id])
    @track.destroy

    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :no_content }
    end
  end

  def statistics

    @row_pie = ""
    if(params[:vendor_id])
      @vendor = Vendor.find_by_slug(params[:vendor_id])
      @tracks = Track.where("vendor_id = ?", @vendor.id)
      @tf = Track.joins(:user).where("vendor_id = ? AND action = ? ", @vendor.id, 'entry').select("first_name, last_name, email, count(tracks.vendor_id) as freq ").group("tracks.user_id").order("freq DESC").limit(10)      
    elsif (params[:user_id])
      @user = User.find(params[:user_id])
      user_id = params[:user_id].split('-')[0]
      @tracks = Track.where("user_id = ?", user_id)
      @tf = Track.joins(:vendor).where("user_id = ? AND action = ? ", @user.id, 'entry').select("name, type, price, email, count(tracks.vendor_id) as freq ").group("tracks.vendor_id").order("freq DESC").limit(10)      
    else
      @tracks = Track.where('1=1')
      @tf = Track.joins(:vendor).select("vendor_id, name, type, price, email, count(tracks.vendor_id) as freq ").group("tracks.vendor_id").order("freq DESC").limit(10)  
    end
    
    Track::TRACK_ACTIONS_LIST.each.with_index do |key, index|
      if index < Track::TRACK_ACTIONS_LIST.size - 1
        @row_pie += "['#{key}', #{ @tracks.where('action = ? ', key).count}],"
      else 
        @row_pie += "['#{key}', #{@tracks.where('action = ? ', key).count}]"
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracks }
    end
    
  end

  def sort_column
    Track.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
