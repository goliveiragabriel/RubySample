# encoding: utf-8
class AddressesController < ApplicationController
  load_and_authorize_resource :vendor
  load_and_authorize_resource :address, :through => :vendor

  # GET /addresses
  # GET /addresses.json
  def index

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @addresses }
    end
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @address }
    end
  end

  # GET /addresses/new
  # GET /addresses/new.json
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @address }
    end
  end

  # GET /addresses/1/edit
  def edit

  end

  # POST /addresses
  # POST /addresses.json
  def create

    respond_to do |format|
      if @address.save
        format.html { redirect_to vendor_address_path(@vendor, @address), notice: 'Address was successfully created.' }
        format.json { render json: @address, status: :created, location: @address }
      else
        format.html { render action: "new" }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /addresses/1
  # PUT /addresses/1.json
  def update

    respond_to do |format|
      if @address.update_attributes(params[:address])
        format.html { redirect_to vendor_address_path(@vendor, @address), notice: 'Address was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @vendor.addresses.size > 1 ? @address.destroy : flash[:alert] = "Você não pode deletar o único endereço deste fornecedor"

    respond_to do |format|
      format.html { redirect_to vendor_addresses_path(@vendor) }
      format.json { head :no_content }
    end
  end
end
