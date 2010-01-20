class PingerFeed
	attr_accessor :user, :password

	def setup(config={})
		self.user = config['login']
		self.password = config['password']
	end
	
	def send(options={})
		url = URI.parse("http://a.pinger.pl/auth_add_message.json")
		req = Net::HTTP::Post.new(url.path)
		
		req.basic_auth self.user, self.password
		
		body = options[:msg]
		body += " - " + options[:link] if options[:link]
		
		req.set_form_data({'text'=>body, 'tags'=>options[:tags].join(', ')}, '&')
		res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
	end
end