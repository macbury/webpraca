every :hour do # Many shortcuts available: :hour, :day, :month, :year, :reboot
 	rake "validates_captcha:create_static_images COUNT=50"
end
