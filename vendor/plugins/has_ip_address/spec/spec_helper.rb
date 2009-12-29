$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'has_ip_address'
require 'acts_as_fu'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.include ActsAsFu
end
