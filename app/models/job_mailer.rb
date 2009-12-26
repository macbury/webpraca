class JobMailer < ActionMailer::Base
  include ActionController::UrlWriter

	def job_posted(job)
		setup_email(job.email)
		@subject = "webpraca.net - Dodano nową oferte"
		@body[:job] = job
		@body[:job_path] = seo_job_url(job)
		@body[:publish_path] = publish_job_url(job, :token => job.token)
		@body[:edit_path] = edit_job_url(job, :token => job.token)
	end
	
  protected
    
    def setup_email(email)
      @recipients  = email
      #@subject     = "[mycode] "
      @sent_on     = Time.now
      @from        = ActionMailer::Base.smtp_settings[:from]
			default_url_options[:host] = "webpraca.net"
			
    end
end
