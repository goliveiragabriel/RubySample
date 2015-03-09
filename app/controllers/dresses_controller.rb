#encoding: utf-8
# t.integer  "vendor_id"
# t.string   "name"
# t.string   "brand"
# t.string   "description"
# t.boolean  "featured"
# t.integer  "share",                      :default => 0
# t.string   "sleeve"
# t.string   "neckline"
# t.string   "silhouette"
# t.string   "fabric"
# t.string   "length"
# t.integer  "price",       :limit => 255
# t.float    "weight"
# t.datetime "created_at",                                :null => false
# t.datetime "updated_at",                                :null => false
# t.string   "train"
# t.string   "finish"
# t.string   "color"
class DressesController < AuthorizedController
  helper_method :sort_column, :sort_direction

  # GET /dresses
  # GET /dresses.json
  def index

    #if params.size > 2 && !params[:sort]
    #  filters = Hash.new
    #  loaded_params = params.slice(:sleeve, :neckline, :silhouette, :fabric, :length, :price, :train, :finish, :color)
    #  loaded_params.each_pair do |key, value|
    #    filters[key] =  value
    #  end
    #  @dresses = @dresses.where{filters}
    #end
    if params['filters']
      filters = Hash.new
      session[:filters] = params['filters']
      params['filters'].each_pair do |key, value|
        filter_type = key.split("_")[0]
        filters[filter_type] ||= []
        filters[filter_type] << value
      end
      filters.each_pair do |key, value| 
        @dresses = @dresses.where{__send__(key).like_any value}
      end 
    else
      session[:filters] = params['filters']
      if session[:filters]
        filters = Hash.new
        session[:filters].each_pair do |key, value|
          key = key.gsub(/[0-9|_]/i,'')
          filters[key] ||= []
          filters[key] << value
        end
        @dresses = @dresses.where{filters}
      end
      session[:filters] = nil
    end
    # if session[:filters]
    #   @dresses = @dresses.where{session[:filters]}
    # end      
    @dresses = @dresses.order("#{params[:sort]} desc") if params[:sort]
    @featured_dresses = @dresses.where{featured > 0}.order("featured desc")
    @regular_dresses = @dresses - @featured_dresses

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @dresses }
    end

  end

  # GET /dresses/1
  # GET /dresses/1.json
  def show
    @dress = Dress.find(params[:id])
    # Exibe os @random_dress. Se session, parseia o filtro por regexp, seleciona os objetos em um array de ids, 
    # busca a posição do vestido selecionado no respectivo array e busca um subset de 3 vestidos, inclusive o selecionado.
    if session[:filters]

      filters = Hash.new
      session[:filters].each_pair do |key, value|
        key = key.gsub(/[0-9|_]/i,'')
        filters[key] ||= []
        filters[key] << value
      end
      
      @random_dress = Dress.where{filters}
      dresses_id = @random_dress.pluck(:id)
      position = dresses_id.index(@dress.id)
      last = dresses_id.index(dresses_id.last)

      if @random_dress.count > 2
        if (position != 0) && !(position == last)
          @random_dress = @random_dress.where( :id => ( dresses_id[position-1] )..( dresses_id[position+1] ) )
          @current = 1
        elsif position == 0
          @random_dress = @random_dress.where( :id => ( dresses_id[position] )..( dresses_id[position+2] ) )
          @current = 0
        else
          @random_dress = @random_dress.where( :id => ( dresses_id[position-2] )..( dresses_id[position] ) )
          @current = 2
        end
      end

    else
      dresses_id =Dress.pluck(:id)
      position = dresses_id.index(@dress.id)
      last = dresses_id.index(dresses_id.last)

      if (position != 0) && !(position == last)
        @random_dress = Dress.where( :id => ( dresses_id[position-1] )..( dresses_id[position+1] ) )
          @current = 1
      elsif position == 0
        @random_dress = Dress.where( :id => ( dresses_id[position] )..( dresses_id[position+2] ) )
          @current = 0
      else
        @random_dress = Dress.where( :id => ( dresses_id[position-2] )..( dresses_id[position] ) )
          @current = 2
      end

    end

    record_track_dress(@dress.id)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dress }
    end
  end

  # GET /dresses/new
  # GET /dresses/new.json
  def new
    @dress = Dress.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dress }
    end
  end

  # GET /dresses/1/edit
  def edit
    @dress = Dress.find(params[:id])
  end

  # POST /dresses
  # POST /dresses.json
  def create
    @dress = Dress.new(params[:dress])

    respond_to do |format|
      if @dress.save
        format.html { redirect_to @dress, notice: 'Vestido criado com sucesso.' }
        format.json { render json: @dress, status: :created, location: @dress }
      else
        format.html { render action: "new" }
        format.json { render json: @dress.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dresses/1
  # PUT /dresses/1.json
  def update
    @dress = Dress.find(params[:id])

    respond_to do |format|
      if @dress.update_attributes(params[:dress])
        format.html { redirect_to @dress, notice: 'Vestido atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dress.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dresses/1
  # DELETE /dresses/1.json
  def destroy
    @dress = Dress.find(params[:id])
    @dress.destroy

    respond_to do |format|
      format.html { redirect_to dresses_url }
      format.json { head :no_content }
    end
  end

  def update_share
    @dress.share += 1
    respond_to do |format|
      if @dress.save
        format.js { render nothing: true }
        format.html { redirect_to @dress }
      end
    end
  end

  def vendor
    if params[:vid]
      @dresses = Dress.where("vendor_id = ?", params[:vid])
    end
  end

  private
  
  def sort_column
    Dress.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
