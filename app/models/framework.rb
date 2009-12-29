class Framework < ActiveRecord::Base
	xss_terminate
	has_permalink :name
	
	has_many :jobs
	
	def self.find_job_frameworks
		query = Job.search
		query.end_at_greater_than_or_equal_to(Date.current)
		query.published_is(true)
		
		return query.all(:select => "count(jobs.framework_id) as jobs_count, frameworks.*",
											:joins => :framework,
											:group => Framework.column_names.map{|c| "frameworks.#{c}"}.join(','),
											:order => "frameworks.name")
	end
	
	def to_param
		permalink
	end
end
