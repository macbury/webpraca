module JobsHelper
	def job_label(job)
		html = ""
		html += etykieta(job.type_id)
		html += content_tag :abbr, t("jobs.type.remote"), :class => "etykieta remote" if job.remote_job
		
		return html
	end
	
	def etykieta(type_id)
		content_tag :abbr, t("jobs.type.#{JOB_TYPES[type_id]}"), :class => "etykieta #{JOB_TYPES[type_id]}", :title => t("jobs.type.#{JOB_TYPES[type_id]}")
	end
	
	def format_rank(rank)
		((rank*10).round/10.0).to_s.gsub('.', ',')
	end
	
	def job_company(job)
		if job.website.nil? || job.website.empty?
			job.company_name
		else
			link_to job.company_name, job.website, :target => "_blank"
		end
	end
end
