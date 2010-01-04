require 'erb'

class StupidSimpleConfig < Hash
	attr_accessor :yaml_file

	def initialize(yaml_file)
		self.yaml_file = "#{RAILS_ROOT}/config/#{yaml_file}"
		load!
	end
	
	def save!
		File.open(self.yaml_file, "w") do |out|
			YAML.dump(self, out)
		end
	end
	
	def update_attributes(attributes={})
		self.merge!(attributes)
		self.save!
	end
	
	def load!
		self.merge!(YAML::load(ERB.new(IO.read(self.yaml_file)).result))
	end
end