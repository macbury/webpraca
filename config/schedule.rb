set :environment, "production"
set :output, '/home/webpraca/www/apps/webpraca/shared/log/cron.log'
env :GEM_PATH, '/home/webpraca/www/.ruby/gems/1.8:/var/lib/gems/1.8/'

every 1.day, :at => '1:00 am' do 
 	rake "validates_captcha:create_static_images COUNT=500"
	command "restart-app webpraca"
end

every 1.day, :at => '1:30 am' do
	rake "webpraca:jobs:remove_old"
  rake "sitemap:refresh"
end