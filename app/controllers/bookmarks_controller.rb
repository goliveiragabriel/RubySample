#encoding: utf-8
class BookmarksController < ApplicationController
  before_filter :authenticate_user!
  load_resource :vendor
  load_resource :dress
  load_and_authorize_resource :bookmark, :through => [:vendor, :dress]
  # before_filter :set_model
  
  layout "devise", :except => [:index, :show]

  # GET /bookmarks
  # GET /bookmarks.json
  def index
    if params[:dress_id]
      @bookmarks = @bookmarks.where("bookmarkable_id = ?", params[:dress_id])
    elsif params[:vendor_id]
      @bookmarks = @bookmarks.where("bookmarkable_id = ?", params[:vendor_id])
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookmarks }
    end
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bookmark }
    end
  end

  # GET /bookmarks/new
  # GET /bookmarks/new.json
  def new
    @bookmark.bookmarkable = @vendor || @dress
    bookmarkable = @bookmark.bookmarkable
    url = (bookmarkable.class.to_s == "Dress" ? bookmarkable : vendor_seo_path(bookmarkable))
    # Comentado por Gabriel / Andre revisar
    # if current_user.bookmarked?(bookmarkable)
    #   return redirect_to(url, notice: 'Você já favoritou este item')
    # end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bookmark }
    end
  end

  # GET /bookmarks/1/edit
  def edit
    
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark.bookmarkable = @vendor || @dress
    @bookmark.user = current_user
    bookmarkable = @bookmark.bookmarkable
    url = (bookmarkable.class.to_s == "Dress" ? bookmarkable : vendor_seo_path(bookmarkable))

    # Comentado por Gabriel / Andre revisar
    # if current_user.bookmarked?(bookmarkable)
    #   return redirect_to(bookmarkable, notice: 'Você já favoritou este item')
    # end
    
    respond_to do |format|
      if @bookmark.save!
        format.js
        format.html { redirect_to url, notice: 'Item adicionado com sucesso aos favoritos.' }
        format.json { render json: @bookmark, status: :created, location: @bookmark }
      else
        format.html { render action: "new" }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bookmarks/1
  # PUT /bookmarks/1.json
  def update

    respond_to do |format|
      if @bookmark.update_attributes(params[:bookmark])
        format.html { redirect_to @bookmark, notice: 'Item atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    @bookmarkable = @bookmark.bookmarkable
    #url = (bookmarkable.class.to_s == "Dress" ? bookmarkable : vendor_seo_path(bookmarkable))
    @bookmark.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to request.referer }
      format.json { head :ok }
    end
  end

  def set_model
    params[:dress_id] ? @dress = Dress.find(params[:dress_id]) : @vendor = Vendor.find(params[:vendor_id])
  end
end
