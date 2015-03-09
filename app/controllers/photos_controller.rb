# encoding: utf-8
class PhotosController < ApplicationController
  load_and_authorize_resource :vendor
  load_and_authorize_resource :photo, :through => :vendor

  # GET /photos
  # GET /photos.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    @vendor = @vendor.becomes(Vendor)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @vendor = @vendor.becomes(Vendor)
  end

  # POST /photos
  # POST /photos.json
  def create
    photo_id = @vendor.photos.size + 1
    @photo.vendor = @vendor
    @photo.name = "#{@vendor.translated_type}-#{@vendor.name}-#{photo_id}".parameterize

    respond_to do |format|
      if @photo.save
        @photo_counter = false
        #format.html { redirect_to vendor_photos_path(@vendor), notice: 'Photo was successfully created.' }
        format.js { render text: render_to_string(@photo) }
        #format.json { render json: @photo, status: :created, location: @photo }
      else
        #format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
        #format.js { render js: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to vendor_photo_path(@vendor, @photo), notice: 'Photo was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def bulk_edit

  end

  def bulk_update

    errors = Photo.bulk_update(params["photos"]["id"])
    respond_to do |format|
      format.html { redirect_to vendor_photos_path }
      format.json { head :ok }
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to vendor_photos_path }
      format.json { head :ok }
    end
  end

end
