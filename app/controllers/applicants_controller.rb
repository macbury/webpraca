class ApplicantsController < ApplicationController
	before_filter :get_job
	ads_pos :right
	validates_captcha 
	
  def create
    @applicant = @job.applicants.new(params[:applicant])
    if @applicant.save
      flash[:notice] = "Twoja aplikacja została wysłana"
      redirect_to seo_job_path(@job)
    else
      render :action => 'new'
    end
  end

	def new
		@applicant = @job.applicants.new
	end

	protected 
	
		def get_job
			@job = Job.active.find_by_permalink!(params[:job_id])
			redirect_to seo_job_path(@job) unless @job.apply_online
			
			@page_title = [@job.title, "Aplikuj online"]
		end
end
