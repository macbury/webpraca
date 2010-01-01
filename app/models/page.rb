class Page < ActiveRecord::Base
	has_permalink :name
	
	validates_presence_of :name, :body
	validates_uniqueness_of :name
	
	def to_param
		permalink
	end
end
