#encoding: utf-8
class AppointmentsController < AuthorizedController
  layout "devise", :except => [:index, :quotations, :show]
  #before_filter :set_model
  # GET /appointments
  # GET /appointments.json
  def index
    if (params[:dress_id])
      @dress = Dress.find(params[:dress_id])
      @appointments = @dress.appointments
    elsif (params[:user_id])
      @user = User.find(params[:user_id])
      @appointments = @user.appointments
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @appointments }
    end
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /appointments/new
  # GET /appointments/new.json
  def new
    @appointment = Appointment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appointment }
    end
  end

  # GET /appointments/1/edit
  def edit
    @appointment = Appointment.find(params[:id])
  end

  # POST /appointments
  # POST /appointments.json
  def create
    @appointment = Appointment.new(params[:appointment])
    current_user.telephone ||= @appointment.telephone
    current_user.save
    freq_condition = TrackDress.count(:joins => "LEFT JOIN dresses on track_dresses.dress_id = dresses.id", :group => "track_dresses.dress_id")
    freq_condition = freq_condition.sort {|a,b| b[1] <=> a[1]}    
    #@track_dresses = TrackDress.joins(:dress).where("user_id = ? ", current_user.id).group("track_dresses.dress_id").order("freq DESC").limit(10)
    @favourite_dresses = Bookmark.where("user_id = ? AND bookmarkable_type = ?", current_user.id, Dress.to_s).limit(6)
    @track_dresses = Dress.where(:id => freq_condition).limit(6)

    UserMailer.appointment_created(@appointment, @track_dresses, @favourite_dresses).deliver
    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment.dress, notice: 'Visita agendada com sucesso.' }
        format.json { render json: @appointment, status: :created, location: @appointment }
      else
        format.html { render action: "new" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /appointments/1
  # PUT /appointments/1.json
  def update
    @appointment = Appointment.find(params[:id])

    respond_to do |format|
      if @appointment.update_attributes(params[:appointment])
        format.html { redirect_to @appointment, notice: 'Visita atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to appointments_url }
      format.json { head :no_content }
    end
  end

end
