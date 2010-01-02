class Admin::JobsController < ApplicationController
	before_filter :login_required, :setup_title
	layout 'admin'
	
  def index
    @jobs = Job.paginate :page => params[:page], :per_page => 30, :order => "created_at DESC"
  end
  
	def edit
		@page_title << "Edycja oferty pracy"
		@job = Job.find_by_permalink!(params[:id])
	end
	
	def update
    @job = Job.find_by_permalink!(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        flash[:notice] = 'Zapisano zmiany w ofercie.'
        format.html { redirect_to(admin_jobs_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end
	
  def destroy
    @job = Job.find_by_permalink!(params[:id])
    @job.destroy
    flash[:notice] = "Successfully destroyed admin/job."
    redirect_to admin_jobs_url
  end

	protected
		
		def setup_title
			@page_title << "Oferty pracy"
		end
end
