class WidgetsController < ApplicationController
	before_filter :widget_from_params
	ads_pos :right
	
	def new
		
	end
	
	def show
		@jobs = Job.active.all(:order => "RANDOM(), rank DESC, created_at DESC", :limit => 15, :include => [:localization])
		
		@jobs_hash = @jobs.map do |job|
			{
				:title => "#{job.title} dla #{job.company_name} w #{job.localization.name}",
				:id => job.id,
				:type => JOB_LABELS[job.type_id],
				:url => seo_job_url(job)
			}
		end
		
		respond_to do |format|
			format.js { render :layout => false }
		end
	end
	
	protected
		
		def widget_from_params
			@options = {
				:width => "270px",
				:background => "#FFFFFF",
				:border => "#CCCCCC",

			}.merge!(params)
		end
end
