# encoding: utf-8
class MessagesController < AuthorizedController
  prepend_before_filter :record_guest_track, :only => [:new]
  skip_before_filter :authenticate_user!, :only => [:create, :cadastro]

  def index
  end  

  def new
    @vendor = Vendor.find(params[:vid])
    @message.email = current_user.email
    @message.type = "new"
    @message.subject = "[#{@vendor.name}] #{@vendor.discount_title}"
    @message.content = (@vendor.discount_description ? @vendor.discount_description : "") + "\n\nObrigada!\n#{@current_user.name}"

    record_track(@vendor.id, "message")

    respond_to do |format|
      format.html { render action: "new", layout: "devise" }
    end
  end

  def cadastro
    @message = Message.new
    @message.type = "cadastro"
  end

  def atualizacao
    @message = Message.new
    @message.type = "atualizacao"
  end
  
  def create
    @message = Message.new(params[:message])
    if @message.valid?

      if @message.type == "cadastro"
        @message.subject = "Solicitação de Cadastro de Fornecedor - #{@message.nome_fantasia}"
        @message.body = @message.body_cadastro
        @message.proposal = params[:message][:proposal]
        url = root_path
        message = "Solicitação enviada com sucesso. Em breve entraremos em contato com você!"

      elsif @message.type == "atualizacao"
        @message.subject = "Solicitação de Atualização de dados do Fornecedor - #{@message.nome_fantasia}"
        @message.body = @message.body_atualizacao
        url = root_path
        message = "Solicitação enviada com sucesso. Em breve entraremos em contato com você!"

      else
        vendor = Vendor.find(params[:vid])
        @message.subject = "[#{vendor.name}] #{vendor.discount_title}"
        @message.body = @message.content + " - " + @message.email
        url = vendor_seo_path(vendor)
        message = "O seu pedido foi registrado com sucesso"

      end

      UserMailer.message_created(@message).deliver
      # respond_to do |format|
      #   format.html{ redirect_to pagamento_messages_path(:proposal => params[:message][:featured]), layout: "devise" }
      # end
       redirect_to url, notice: message
    else

      respond_to do |format|
        format.html { render action: @message.type }
      end
    end
  end

  def termo
    respond_to do |format|
      format.html { render action: "termo", layout: "devise" }
    end    
  end

  def pagamento
    @proposal = params[:proposal]
  end

  def record_guest_track
    set_guest_track('message',params[:vid])
  end

end