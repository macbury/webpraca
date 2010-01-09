class Admin::StatsController < ApplicationController
	before_filter :login_required, :setup_title
	layout 'admin'
	
	def index
		job_stats = Job.all(
											:select => "count(jobs.id) as jobs_count, date(created_at) as date",
											:group => "date",
											:order => "date DESC",
											:limit => 90 )

		start = job_stats.map { |job| job.date.to_date }.min
		meta = job_stats.map { |job| job.date.to_date }.max
		@job_stats = {}
		(start..meta).each { |date| @job_stats[date] = 0 }
		job_stats.each { |job| @job_stats[job.date.to_date] = job.jobs_count }
		@job_stats = @job_stats.to_a.sort { |a,b| a[0] <=> b[0] }
	end
	
	def new_jobs
		
	end
	
	protected
	
		def setup_title
			@page_title << "Statystyki"
		end
end
