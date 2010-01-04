require "smtp_tls"
ActionMailer::Base.delivery_method = :smtp   
ActionMailer::Base.default_charset = 'utf-8'
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.smtp_settings = YAML.load_file("#{RAILS_ROOT}/config/mailer.yml")[Rails.env]
ActionMailer::Base.smtp_settings[:tsl] = true
ActionMailer::Base.smtp_settings[:authentication] = :login