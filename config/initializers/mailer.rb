require "smtp_tls"
ActionMailer::Base.delivery_method = :smtp  
ActionMailer::Base.raise_delivery_errors = true  
ActionMailer::Base.default_charset = 'utf-8'
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.smtp_settings = YAML.load_file("#{RAILS_ROOT}/config/mailer.yml")[Rails.env]