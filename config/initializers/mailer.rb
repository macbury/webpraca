if RAILS_ENV != "test" and RAILS_ENV != "cucumber"
  require "smtp_tls"
  ActionMailer::Base.delivery_method = :smtp   
  ActionMailer::Base.default_charset = 'utf-8'
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.raise_delivery_errors = true

  begin
    ActionMailer::Base.smtp_settings = YAML.load_file("#{RAILS_ROOT}/config/mailer.yml")[Rails.env]
  rescue Errno::ENOENT
    raise "Could not find config/website_config.yml, example is in config/website_config.yml.example"
  end

  ActionMailer::Base.smtp_settings[:tsl] = true
  ActionMailer::Base.smtp_settings[:authentication] = :login
end