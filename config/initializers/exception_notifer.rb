begin
  ExceptionNotifier.exception_recipients = YAML.load_file(Rails.root.join("config/exception_notifier.yml"))[Rails.env]
rescue Errno::ENOENT
  raise "Could not find config/exception_notifier.yml, example is in config/exception_notifier.yml.example"
end
