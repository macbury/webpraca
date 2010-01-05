class JobMailer < ActionMailer::Base
  include ActionController::UrlWriter
	
	def job_applicant(applicant)
		setup_email(applicant.job.email)
		if applicant.job.email_title.nil? || applicant.job.email_title.empty?
			@subject = "webpraca.net - Pojawiła się osoba zainteresowana ofertą '#{applicant.job.title}'"
		else
			@subject = applicant.job.email_title
		end
		@body[:job] = applicant.job
		@body[:applicant] = applicant
		@body[:job_path] = seo_job_url(applicant.job)
		@body[:attachment_path] = download_job_applicant_url(applicant.job, applicant.token) if applicant.have_attachment?
	end
	
	def job_posted(job)
		setup_email(job.email)
		@subject = "webpraca.net - Twoja oferta została dodana"
		@body[:job] = job
		@body[:job_path] = seo_job_url(job)
		@body[:publish_path] = publish_job_url(job, :token => job.token)
		@body[:edit_path] = edit_job_url(job, :token => job.token)
		@body[:destroy_path] = destroy_job_url(job, :token => job.token)
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
