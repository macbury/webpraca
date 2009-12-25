Less::Plugin.options[:template_location] = "#{RAILS_ROOT}/app/stylesheets"
Less::Plugin.options[:css_location] = "#{RAILS_ROOT}/public/stylesheets"
Less::Plugin.options[:update] = :when_changed
Less::Plugin.options[:compress] = false