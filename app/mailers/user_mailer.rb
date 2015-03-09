# encoding: utf-8
class UserMailer < ActionMailer::Base
  default :from => Yetting.email_address
  
  def welcome_message(user)
    @user = user
    mail(to: user.email_signature, 
         bcc: Yetting.email_address,
         subject: "Seja bem vindo ao Bem Casados!")
  end
  
  def review_submitted(review)
    @review = review
    @vendor = review.vendor
    @user = review.user
    mail(to: Yetting.email_address, 
         subject: "Nova recomendação para #{@vendor.name}")
  end
  
  def quotation_submitted(quotation)
    @quotation = quotation
    @vendor = quotation.vendor
    @user = quotation.user
    mail(to: @vendor.email, 
         subject: "Novo orçamento para #{@vendor.name}")
  end
  # E-mail enviado ao Fornecedor sobre o Orçamento personalizados
  def quotation_created(quotation)
    @quotation = quotation
    @vendor = quotation.vendor
    @user = quotation.user
    mail(to: @vendor.email ? @vendor.email : @vendor.email2,
         # cc: "isabel@bemcasados.art.br",
         subject: "Pedido de orçamento - Bem Casados")
  end

  def message_created(message)
    unless message.proposal.nil?
      file = message.proposal
      attachments[file.original_filename] = file.read
    end
    mail(to: Yetting.email_address,
         #to: 'goliveiragabriel@gmail.com',
         subject: message.subject,
         body: message.body)
  end

  def tester_email(user)
    @user = user
    # attachments["bemcasados.png"] = File.read("#{Rails.root}/public/images/bemcasados.png")  
    mail(to: @user.email_signature,
         subject: "#{user.name}, temos novidades pra você.")
  end

  def appointment_created(appointment, track_dress, favourite_dresses)
    @favourite_dresses = favourite_dresses
    @track_dresses = track_dress
    @appointment = appointment
    @user = appointment.user
    @vendor = appointment.dress.vendor
    mail(#to: @vendor.email, 
         to: Yetting.email_address,
         subject: "#{@vendor.name}, foi agendada uma visita para você.")
  end

  def newsletter(vendor)
    @vendor = vendor
    mail(to: @vendor.email2,
    subject: "#{@vendor.name}, exponha o seu sucesso para mais noivas.")
  end

  def vendor_reviews(vendor)
    @vendor = vendor
    mail(to: @vendor.email2,
      subject: "#{@vendor.reviews.last.user.male? ? 'O noivo ' << @vendor.reviews.last.user.name : 'A noiva ' << @vendor.reviews.last.user.name } escreveu uma recomendação para você!")
  end

  def user_request_proposal(user, vendor)
    @user = user
    @vendor = vendor
    attachments[File.basename(@vendor.proposal.document.path.to_s)] = @vendor.proposal.document.read
    mail(to: @user.email,
      subject: "Orçamento Instantâneo - #{@vendor.name}")
  end

  # E-mail do orçamento personalizado encaminhado para a noiva
  def user_proposal(user, quotation)
    @user = user
    @vendor = quotation.vendor
    @quotation = quotation
    mail(to: @user.email,
      # cc: "isabel@bemcasados.art.br",
      subject: "Pedido de Orçamento - #{@vendor.name}"
      )
  end

end