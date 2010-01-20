class Language < ActiveRecord::Base
	has_many :jobs, :dependent => :delete_all
	xss_terminate
	has_permalink :name
	
	def to_param
		permalink
	end
	
	def self.find_job_languages
		return Language.all(	
											:select => "count(jobs.language_id) as jobs_count, languages.*",
											:conditions => ["((jobs.end_at >= ?) AND (jobs.published = ?))", Date.current, true],
											:joins => :jobs,
											:group => Language.column_names.map{|c| "languages.#{c}"}.join(','),
											:order => "languages.name")
	end
end
