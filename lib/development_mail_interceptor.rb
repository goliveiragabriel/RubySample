class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} - #{message.subject}"
    message.to = ["andreteves@gmail.com"]
    message.bcc = ["goliveiragabriel@gmail.com"]
  end
end