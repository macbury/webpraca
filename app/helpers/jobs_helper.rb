module JobsHelper
	def job_label(job)
		html = ""
		html += content_tag :span, JOB_LABELS[job.type_id], :class => "etykieta #{JOB_LABELS[job.type_id]}"
		html += content_tag :span, "Praca zdalna", :class => "etykieta zdalnie" if job.remote_job
		
		return html
	end
end
