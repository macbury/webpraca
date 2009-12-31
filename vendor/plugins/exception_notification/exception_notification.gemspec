Gem::Specification.new do |s|
  s.name = "jeremyevans-exception_notification"
  s.version = "1.0.20090728"
  s.date = "2009-07-28"
  s.summary = "Gemified exception_notification rails plugin, compatible with Rails 2.3"
  s.email = "code@jeremyevans.net"
  s.homepage = "http://github.com/jeremyevans/exception_notification"
  s.has_rdoc = true
  s.authors = ["Rails Core Team"]
  s.files = [
    "lib/exception_notifiable.rb",
    "lib/exception_notification.rb",
    "lib/exception_notifier.rb",
    "lib/exception_notifier_helper.rb",
    "rails/init.rb",
    "README",
    "test/exception_notifier_helper_test.rb",
    "test/test_helper.rb",
    "views/exception_notifier/_backtrace.rhtml",
    "views/exception_notifier/_environment.rhtml",
    "views/exception_notifier/_inspect_model.rhtml",
    "views/exception_notifier/_request.rhtml",
    "views/exception_notifier/_session.rhtml",
    "views/exception_notifier/_title.rhtml",
    "views/exception_notifier/exception_notification.rhtml"
  ]
  s.test_files = [
    "test/exception_notifier_helper_test.rb",
    "test/test_helper.rb"
  ]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
end
