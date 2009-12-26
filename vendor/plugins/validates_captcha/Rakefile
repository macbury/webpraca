require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'

require File.join(File.dirname(__FILE__), 'lib', 'validates_captcha', 'version')



PKG_NAME = 'validates_captcha'
PKG_VERSION = ValidatesCaptcha::VERSION::STRING
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

RELEASE_NAME = "REL #{PKG_VERSION}"

RUBY_FORGE_PROJECT = 'validatecaptcha'



begin
  require 'hanna/rdoctask'
rescue LoadError
  require 'rake/rdoctask'
end

desc 'Generate documentation'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "Validates Captcha"
  rdoc.main = "README.rdoc"

  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.options << '--charset' << 'utf-8'

  rdoc.rdoc_files.include 'README.rdoc'
  rdoc.rdoc_files.include 'MIT-LICENSE'
  rdoc.rdoc_files.include 'CHANGELOG.rdoc'
  rdoc.rdoc_files.include 'lib/**/*.rb'
  rdoc.rdoc_files.exclude 'lib/validates_captcha/test_case.rb'
  rdoc.rdoc_files.exclude 'lib/validates_captcha/version.rb'
end

namespace :rdoc do
  desc 'Show documentation in Firefox'
  task :show do
    sh 'firefox doc/index.html'
  end
end



desc 'Run tests by default'
task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  #t.verbose = true
  #t.warning = true
end



spec = eval(File.read('validates_captcha.gemspec'))

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
  pkg.need_tar = true
  pkg.need_zip = true
end



desc 'Publish the release files to RubyForge'
task :release => [:package] do
  require 'rubyforge'
  require 'rake/contrib/rubyforgepublisher'

  packages = %w(gem tgz zip).collect { |ext| "pkg/#{PKG_NAME}-#{PKG_VERSION}.#{ext}" }

  rubyforge = RubyForge.new
  rubyforge.configure
  rubyforge.add_release RUBY_FORGE_PROJECT, RUBY_FORGE_PROJECT, RELEASE_NAME, *packages
end



desc 'Uninstall local gem'
task :uninstall do
  system "sudo gem uninstall #{PKG_NAME}"
end

desc 'Install local gem'
task :install => [:uninstall, :gem] do
  system "sudo gem install pkg/#{PKG_NAME}-#{PKG_VERSION}.gem --no-ri --no-rdoc"
end



Dir['tasks/**/*.rake'].each { |tasks_file| load tasks_file }

