class BlipFeed
	attr_accessor :user, :password

	def setup(config={})
		self.user = config['login']
		self.password = config['password']
	end
	
	def send(options={})
		url = URI.parse("http://api.blip.pl/updates")
		req = Net::HTTP::Post.new(url.path)
		
		req.basic_auth self.user, self.password
		
		body = options[:msg]
		body += " - " + options[:link] if options[:link]
		body += " " + options[:tags].map { |tag| "##{tag}" }.join(', ') if options[:tags]
		
		req.set_form_data({ 'body'=>body, 'User-Agent' => 'http://github.com/macbury/MicroFeed', 'Accept' => 'application/json', 'X-Blip-API' => '0.02'}, '&')
		res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
	end

end