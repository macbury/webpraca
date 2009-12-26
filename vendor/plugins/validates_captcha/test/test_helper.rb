$:.unshift File.dirname(__FILE__) + '/../../lib'

require 'rubygems'
require 'test/unit'

require 'validates_captcha'

begin
  require 'ruby-debug'
  Debugger.start
rescue LoadError
end

require 'active_record'

ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Schema.verbose = false
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'
ActiveRecord::Schema.define :version => 1 do
  create_table :widgets do |t|
    t.string :name
  end
end

class Widget < ActiveRecord::Base
  include ValidatesCaptcha::ModelValidation

  attr_accessible :name
end

