class ContactMailer < ActionMailer::Base
  include ExceptionNotifiable

  def contact_notification(contact_handler)
    
    @recipients  = contact_handler.job.nil? ? ExceptionNotifier.exception_recipients : contact_handler.job.email
    @from        = ActionMailer::Base.smtp_settings[:from]
    @subject     = "Kontakt od: #{contact_handler.email}"
    
    @body[:contact_handler] = contact_handler
    
  end

end