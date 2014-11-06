ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  :access_key_id     => Yetting.aws_access_key_id,
  :secret_access_key => Yetting.aws_secret_access_key

# O envio de email por smtp não funciona na máquina da Amazon (apenas local)
ActionMailer::Base.smtp_settings = {
  :address              => "email-smtp.us-east-1.amazonaws.com",
  :port                 => 465,
  :domain               => Yetting.domain_name,
  :authentication       => :login,
  :user_name            => Yetting.ses_smtp_username,
  :password             => Yetting.ses_smtp_password
}

ActionMailer::Base.delivery_method = :ses
ActionMailer::Base.default_url_options = { host: Yetting.domain_name }

require 'development_mail_interceptor'
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

AWS::SES::SendEmail.class_eval do
  #TN: made bbc work with ses (https://github.com/drewblas/aws-ses/issues/16)
  def send_raw_email(mail, args = {})
    message = mail.is_a?(Hash) ? Mail.new(mail).to_s : mail.to_s
    package = { 'RawMessage.Data' => Base64::encode64(message) }
    package['Source'] = args[:from] if args[:from]
    package['Source'] = args[:source] if args[:source]
    
    # Extract the list of recipients based on arguments or mail headers
    destinations = []
    if args[:destinations]
      destinations.concat args[:destinations].to_a
    elsif args[:to]
      destinations.concat args[:to].to_a
    else
      destinations.concat mail.to.to_a
      destinations.concat mail.cc.to_a
      destinations.concat mail.bcc.to_a
    end
    add_array_to_hash!(package, 'Destinations', destinations) if destinations.length > 0
    
    request('SendRawEmail', package)
  end
  
  alias :deliver! :send_raw_email
  alias :deliver  :send_raw_email
    
end