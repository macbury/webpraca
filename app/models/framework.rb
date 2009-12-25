class Framework < ActiveRecord::Base
	xss_terminate
	has_permalink :name
	
	has_many :jobs
end
