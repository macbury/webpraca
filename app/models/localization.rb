class Localization < ActiveRecord::Base
	has_many :jobs
	
	xss_terminate
	has_permalink :name
	
	def self.find_job_localizations
		query = Job.search
		query.end_at_greater_than_or_equal_to(Date.current)
		query.published_is(true)
		
		return query.all(:select => "count(jobs.localization_id) as jobs_count, localizations.*",
											:joins => :localization,
											:group => Localization.column_names.map{|c| "localizations.#{c}"}.join(','),
											:order => "localizations.name")
	end
end
