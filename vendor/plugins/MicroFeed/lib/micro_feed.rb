require "net/http"
require "uri"

require "feeds/blip_feed"
require "feeds/flaker_feed"
require "feeds/spinacz_feed"
require "feeds/pinger_feed"
require "feeds/twitter_feed"

class MicroFeed
	MICRO_FEED_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/micro_feed.yml")
	# Wysyła wiadomość do podanych serwisów mikroblogowych
  # Dostępne opcje:
  # * +:streams+: serwisy do których ma dojść wiadomość(:all, [:blip, :flaker], :blip)
  # * +msg+: treść wiadomości
  # * +link+: link do strony
  # * +tags+: tablica z tagami(np. ['sport', 'telewizja'])
	
	def self.send(config={})
		default = {
			:streams => :all, 
			:msg => "Hello World!", 
			:link => nil, 
			:tags => nil
		}.merge!(config)
		
		available_streams = MICRO_FEED_CONFIG.map { |stream, config| stream.to_sym }
		
		if default[:streams] == :all
			send_to = available_streams
		elsif default[:streams].class == Symbol
			send_to = available_streams.include?(default[:streams].to_sym) ? [default[:streams]] : available_streams
		else
			send_to = default[:streams].reject { |stream| !available_streams.include?(stream.to_sym) }
		end
		
		send_to.each do |stream_name|
			config = MICRO_FEED_CONFIG[stream_name.to_s]
			sender = eval("#{stream_name.to_s.camelize}Feed").new
			sender.setup(config)
			sender.send(default)
		end
	end
end