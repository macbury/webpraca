Less::Plugin.options[:template_location] = "#{RAILS_ROOT}/app/stylesheets"
Less::Plugin.options[:css_location] = "#{RAILS_ROOT}/public/stylesheets"
Less::Plugin.options[:update] = :always
Less::Plugin.options[:compress] = false