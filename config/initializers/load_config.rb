begin
  ::WebSiteConfig = StupidSimpleConfig.new("website_config.yml")
rescue Errno::ENOENT
  raise "Could not find config/website_config.yml, example is in config/website_config.yml.example"
end
