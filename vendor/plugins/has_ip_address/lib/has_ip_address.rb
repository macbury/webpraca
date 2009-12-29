require 'ipaddr'
require 'has_ip_address/extensions'

module HasIpAddress

  def self.included(other)
    other.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def has_ip_address(column = :ip_address)
      define_method "#{column}=" do |address|
        ipaddr = address.to_ipaddr
        write_attribute column, ipaddr

        ipaddr
      end

      define_method column do
        integer = read_attribute column
        if integer.present?
          IPAddr.new(i_to_ipaddr(integer))
        end
      end

      unless self.instance_methods.include?('i_to_ipaddr')
        define_method :i_to_ipaddr do |i|
          [24, 16, 8, 0].collect {|b| (i >> b) & 255}.join('.')
        end
      end      
    end
  end
end

require 'active_record'
ActiveRecord::Base.class_eval do
  include HasIpAddress
end
