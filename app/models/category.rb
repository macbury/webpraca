class Category < ActiveRecord::Base
	has_many :jobs, :dependent => :delete_all
	xss_terminate
	has_permalink :name
	
	before_create :set_position
	validates_presence_of :name
	validates_uniqueness_of :name
	
	def set_position
		self.position = Category.count || 0
		self.position += 1
	end
	
	def to_param
		permalink
	end
end
