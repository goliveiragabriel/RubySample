# encoding: utf-8
class ProposalsController < AuthorizedController
  # GET /proposals
  # GET /proposals.json
  def index
    @proposals = Proposal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.json
  def show
    @proposal = Proposal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/new
  # GET /proposals/new.json
  def new
    @proposal = Proposal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @proposal }
    end
  end

  # GET /proposals/1/edit
  def edit
    @proposal = Proposal.find(params[:id])
  end

  # POST /proposals
  # POST /proposals.json
  def create
    @proposal = Proposal.new(params[:proposal])
    vendor = @proposal.vendor
    unless vendor.email?
      vendor.email2 = @proposal.vendor_email
      vendor.save!
    end
    respond_to do |format|
      if @proposal.save
        #format.html { redirect_to @proposal, notice: 'Proposal was successfully created.' }
        format.html { redirect_to vendor_seo_path(vendor), notice: 'Orçamento Instantãneo criado com sucesso.' }
        format.json { render json: @proposal, status: :created, location: @proposal }
      else
        format.html { render action: "new" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /proposals/1
  # PUT /proposals/1.json
  def update
    @proposal = Proposal.find(params[:id])

    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        format.html { redirect_to @proposal, notice: 'Orçamento instantâneo atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  def vendors
    @vendors = Vendor.order(:name).where("name like ?", "%#{params[:term]}%")
    #render json: @vendors.map(&:name)
    vendors_json = @vendors.map do |v|
      { :name => v.name, :id => v.id, :email => v.email.blank? ? v.email2.blank? ? '' : v.email2 : v.email }
    end
    render json: vendors_json
    # respond_to do |format|
    #   format.json { render :json => vendors_json }
    # end

  end

  # DELETE /proposals/1
  # DELETE /proposals/1.json
  def destroy
    @proposal = Proposal.find(params[:id])
    @proposal.destroy

    respond_to do |format|
      format.html { redirect_to proposals_url }
      format.json { head :no_content }
    end
  end
end
