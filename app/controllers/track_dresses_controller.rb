class TrackDressesController < AuthorizedController
  # GET /track_dresses
  # GET /track_dresses.json
  def index
    if params[:dress_id]
      @track_dresses = TrackDress.where(:dress_id => params[:dress_id])
      @track_dresses = @track_dresses.order("created_at DESC")
      @dress = Dress.find(params[:dress_id])
    elsif params[:user_id]
      @track_dresses = TrackDress.where(:user_id => params[:user_id])
      @track_dresses = @track_dresses.order("created_at DESC")
      @user ||= User.find(params[:user_id])
    else
      @track_dresses = TrackDress.all
      @track_dresses = @track_dresses.order("created_at DESC")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @track_dresses }
    end
  end

  # GET /track_dresses/1
  # GET /track_dresses/1.json
  def show
    @track_dress = TrackDress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track_dress }
    end
  end

  # GET /track_dresses/new
  # GET /track_dresses/new.json
  def new
    @track_dress = TrackDress.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @track_dress }
    end
  end

  # GET /track_dresses/1/edit
  def edit
    @track_dress = TrackDress.find(params[:id])
  end

  # POST /track_dresses
  # POST /track_dresses.json
  def create
    @track_dress = TrackDress.new(params[:track_dress])

    respond_to do |format|
      if @track_dress.save
        format.html { redirect_to @track_dress, notice: 'Track dress was successfully created.' }
        format.json { render json: @track_dress, status: :created, location: @track_dress }
      else
        format.html { render action: "new" }
        format.json { render json: @track_dress.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /track_dresses/1
  # PUT /track_dresses/1.json
  def update
    @track_dress = TrackDress.find(params[:id])

    respond_to do |format|
      if @track_dress.update_attributes(params[:track_dress])
        format.html { redirect_to @track_dress, notice: 'Track dress was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @track_dress.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /track_dresses/1
  # DELETE /track_dresses/1.json
  def destroy
    @track_dress = TrackDress.find(params[:id])
    @track_dress.destroy

    respond_to do |format|
      format.html { redirect_to track_dresses_url }
      format.json { head :no_content }
    end
  end

  def statistics
    if params[:dress_id]
      @dress = Dress.find(params[:dress_id])
      @track_dresses = TrackDress.where("dress_id = ?", @dress.id)
      @tf = TrackDress.joins(:user).where("dress_id = ? ", @dress.id).select("first_name, last_name, email, count(users.id) as freq ").group("track_dresses.user_id").order("freq DESC").limit(10)      
    elsif params[:user_id]
      @user ||= User.find(params[:user_id])
      @track_dresses = TrackDress.where("user_id = ?", @user.id).joins(:dress).select("*,dresses.*")
      @tf = TrackDress.joins(:dress).where("user_id = ? ", @user.id).select("dresses.id,name, brand, neckline, silhouette, fabric, finish, price, count(dresses.id) as freq ").group("track_dresses.dress_id").order("freq DESC").limit(10)      
    end
  end
end
