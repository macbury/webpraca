# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

class Object
  def verbose
    $verbose = true
  end
end


unless ARGV.any? {|a| a =~ /^gems/} # Don't load anything when running the gems:* tasks
  require 'sitemap_generator/tasks' rescue LoadError
end
