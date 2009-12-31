class ApplicantsController < ApplicationController
	before_filter :get_job
	ads_pos :right
	validates_captcha :except => :download
	
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
	
	def download
		@applicant = @job.applicants.find_by_token!(params[:id])
		send_file @applicant.cv.path, 
												:type => @applicant.cv_content_type,
												:filename => @applicant.email.gsub('@', '(at)').gsub('.', '(dot)') + File.extname(@applicant.cv_file_name)
												#:x_sendfile => true
	end
	
	protected 
	
		def get_job
			@job = Job.active.find_by_permalink!(params[:job_id])
			redirect_to seo_job_path(@job) unless @job.apply_online
			
			@page_title = [@job.title, "Aplikuj online"]
		end
end
