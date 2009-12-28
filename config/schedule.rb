every :hour do # Many shortcuts available: :hour, :day, :month, :year, :reboot
 	rake "validates_captcha:create_static_images COUNT=50"
end

every 1.day, :at => '1:30 am' do
  rake "sitemap:refresh"
end