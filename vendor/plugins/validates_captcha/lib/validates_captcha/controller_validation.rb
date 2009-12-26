module ValidatesCaptcha
  module ControllerValidation
    def self.included(base) #:nodoc:
      base.extend ClassMethods
    end

    # This module extends ActionController::Base with methods for captcha
    # verification.
    module ClassMethods
      # This method is the one Validates Captcha got its name from. It
      # internally calls #validates_captcha_of with the name of the controller
      # as first argument and passing the conditions hash.
      #
      # Usage Example:
      #
      #  class UsersController < ApplicationController
      #    # Whenever a User gets saved, validate the captcha.
      #    validates_captcha
      #
      #    def create
      #      # ... user creation code ...
      #    end
      #
      #    # ... more actions ...
      #  end
      def validates_captcha(conditions = {})
        validates_captcha_of controller_name, conditions
      end

      # Activates captcha validation for the specified model.
      #
      # The +model+ argument can be a Class, a string, or a symbol.
      #
      # This method internally creates an around filter, passing the
      # +conditions+ argument to it. So you can (de)activate captcha
      # validation for specific actions.
      #
      # Usage examples:
      #
      #  class UsersController < ApplicationController
      #    validates_captcha_of User
      #    validates_captcha_of :users, :only => [:create, :update]
      #    validates_captcha_of 'user', :except => :persist
      #
      #    # ... actions go here ...
      #  end
      def validates_captcha_of(model, conditions = {})
        model = model.is_a?(Class) ? model : model.to_s.classify.constantize
        without_formats = Array.wrap(conditions.delete(:without)).map(&:to_sym)

        around_filter(conditions) do |controller, action|
          if without_formats.include?(controller.request.format.to_sym)
            action.call
          else
            model.with_captcha_validation do
              action.call
            end
          end
        end
      end
    end
  end
end

