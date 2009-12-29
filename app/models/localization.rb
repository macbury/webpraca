class Localization < ActiveRecord::Base
	has_many :jobs
	
	xss_terminate
	has_permalink :name
	
	def self.find_job_localizations
		return Localization.all(	:select => "count(jobs.localization_id) as jobs_count, localizations.*",
											:joins => :jobs,
											:conditions => ["((jobs.end_at >= ?) AND (jobs.published = ?))", Date.current, true],
											:group => Localization.column_names.map{|c| "localizations.#{c}"}.join(','),
											:order => "localizations.name")
	end
	
	def to_param
		permalink
	end
end
