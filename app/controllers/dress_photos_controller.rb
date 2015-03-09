# encoding: utf-8
class DressPhotosController < ApplicationController
  load_and_authorize_resource :dress
  load_and_authorize_resource :dress_photo, :through => :dress

  # GET /photos
  # GET /photos.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dress_photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dress_photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dress_photo }
    end
  end

  # GET /photos/1/edit
  def edit

  end

  # POST /photos
  # POST /photos.json
  def create
    photo_id = @dress.photos.size + 1
    @dress_photo.dress = @dress
    @dress_photo.name = "vestido-#{@dress.vendor.name}-#{@dress.name}-#{photo_id}".parameterize

    respond_to do |format|
      if @dress_photo.save
        format.js { render text: render_to_string(@dress_photo) }
      else
        format.json { render json: @dress_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    respond_to do |format|
      if @dress_photo.update_attributes(params[:dress_photo])

        format.html { redirect_to dress_dress_photo_path(@dress, @dress_photo), notice: 'Photo was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @dress_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def bulk_edit

  end

  def bulk_update
    errors = DressPhoto.bulk_update(params["dress_photos"]["id"])
    respond_to do |format|
      format.html { redirect_to dress_dress_photos_path }
      format.json { head :ok }
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @dress_photo.destroy
    respond_to do |format|
      format.html { redirect_to dress_dress_photos_path }
      format.json { head :ok }
    end
  end

end
