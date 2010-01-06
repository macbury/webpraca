set :environment, "production"
set :output, '/home/webpraca/www/apps/webpraca/shared/log/cron.log'
env :GEM_PATH, '/home/webpraca/www/.ruby/gems/1.8:/var/lib/gems/1.8/'

every 1.minute do # Many shortcuts available: :hour, :day, :month, :year, :reboot
 	rake "validates_captcha:create_static_images COUNT=50"
end

every 1.day, :at => '1:30 am' do
	rake "webpraca:jobs:remove_old"
  rake "sitemap:refresh"
end