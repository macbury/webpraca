require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "has_ip_address"
    gem.summary = %Q{An extension to ActiveRecord to store IP Addresses in the database as integers}
    gem.description = %Q{An extension to ActiveRecord to store IP Addresses in the database as integers}
    gem.email = "josh@technicalpickles.com"
    gem.homepage = "http://github.com/technicalpickles/has_ip_address"
    gem.authors = ["Joshua Nichols"]
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "yard"
    gem.add_development_dependency "acts_as_fu"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
