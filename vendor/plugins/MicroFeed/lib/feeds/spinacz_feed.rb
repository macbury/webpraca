class SpinaczFeed
	attr_accessor :hash

	def setup(config={})
		self.hash = config['hash']
	end
	
	def send(options={})
    url = URI.parse("http://spinacz.pl/feeds/add.json")
    req = Net::HTTP::Post.new(url.path)
		
		
		body = options[:msg]
		body += " - " + options[:link] if options[:link]
		body += " " + options[:tags].map { |tag| "##{tag}" }.join(', ') if options[:tags] 
		
    req.set_form_data({'content'=> body, 'HASH'=> self.hash}, '&')
    res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
	end
end