require 'rake'
require 'rake/clean'
begin
  require 'hanna/rdoctask'
rescue LoadError
  require 'rake/rdoctask'
end

CLEAN.include ["rdoc"]

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.options += ["--quiet", "--line-numbers", "--inline-source"]
  rdoc.main = "README"
  rdoc.title = "exception_notification: gemified rails plugin, compatible with Rails 2.1"
  rdoc.rdoc_files.add ["README", "lib/**/*.rb"]
end

desc "Package exception_notification"
task :package do
  sh %{gem build exception_notification.gemspec}
end
