class Localization < ActiveRecord::Base
	has_many :jobs
	
	xss_terminate
	has_permalink :name
end
