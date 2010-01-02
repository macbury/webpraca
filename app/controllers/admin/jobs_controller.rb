class Admin::JobsController < ApplicationController
  def index
    @admin/jobs = Admin::Job.all
  end
  
  def destroy
    @admin/job = Admin::Job.find(params[:id])
    @admin/job.destroy
    flash[:notice] = "Successfully destroyed admin/job."
    redirect_to admin/jobs_url
  end
end
