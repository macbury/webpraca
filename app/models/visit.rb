class Visit < ActiveRecord::Base
	belongs_to :job, :counter_cache => true
	has_ip_address :ip
end
