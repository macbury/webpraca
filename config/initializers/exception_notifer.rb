ExceptionNotifier.exception_recipients = YAML.load_file("#{RAILS_ROOT}/config/exception_notifer.yml")[Rails.env]