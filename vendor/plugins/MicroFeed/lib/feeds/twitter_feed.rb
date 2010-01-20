class TwitterFeed
	attr_accessor :user, :password

	def setup(config={})
		self.user = config['login']
		self.password = config['password']
	end
	
	def send(options={})
		headers = {
		  "User-Agent" => "Ruby v1.8",
		  "X-Twitter-Client" => "Ruby",
		  "X-Twitter-Client-Version" => "1.8"
		}

		url = URI.parse("http://twitter.com/statuses/update.xml")
		req = Net::HTTP::Post.new(url.path, headers)

		req.basic_auth(self.user, self.password)

		body = options[:msg]
		body += " - " + options[:link] if options[:link]
		body += " " + options[:tags].map { |tag| "##{tag}" }.join(', ') if options[:tags]

		req.set_form_data({'status' => body, 'source' => 'webpage'})

		response = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
	end
end