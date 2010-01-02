class ContactMailer < ActionMailer::Base
  include ExceptionNotifiable

  def contact_notification(contact_handler)
    
    @recipients  = contact_handler.job.nil? ? ExceptionNotifier.exception_recipients : contact_handler.job.email
    @from        = contact_handler.email
    @subject     = "Kontakt od: #{contact_handler.subject}"
    
    @body[:contact_handler] = contact_handler
    
  end

end