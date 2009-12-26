module ValidatesCaptcha
  module ModelValidation
    def self.included(base) #:nodoc:
      base.extend ClassMethods
      base.send :include, InstanceMethods

      base.class_eval do
        attr_accessor :captcha_solution
        attr_writer :captcha_challenge

        alias_method_chain :attributes=, :captcha_fields

        validate :validate_captcha, :if => :validate_captcha?
      end
    end

    module ClassMethods
      # Activates captcha validation on entering the block and deactivates
      # captcha validation on leaving the block.
      #
      # Example:
      #
      #   User.with_captcha_validation do
      #     @user = User.new(...)
      #     @user.save
      #   end
      def with_captcha_validation(&block)
        self.validate_captcha = true
        result = yield
        self.validate_captcha = false
        result
      end

      # Returns +true+ if captcha validation is activated, otherwise +false+.
      def validate_captcha? #:nodoc:
        @validate_captcha == true
      end

      private
        def validate_captcha=(value) #:nodoc:
          @validate_captcha = value
        end
    end

    module InstanceMethods #:nodoc:
      def captcha_challenge #:nodoc:
        return @captcha_challenge unless @captcha_challenge.blank?
        @captcha_challenge = ValidatesCaptcha.provider.generate_challenge
      end

      def attributes_with_captcha_fields=(new_attributes, guard_protected_attributes = true)
        if new_attributes && guard_protected_attributes &&
            (new_attributes.key?('captcha_challenge') || new_attributes.key?(:captcha_challenge))
          attributes = new_attributes.dup
          attributes.stringify_keys!

          self.captcha_challenge = attributes.delete('captcha_challenge')
          self.captcha_solution = attributes.delete('captcha_solution')

          new_attributes = attributes
        end

        send :attributes_without_captcha_fields=, new_attributes, guard_protected_attributes
      end

      private
        def validate_captcha? #:nodoc:
          self.class.validate_captcha?
        end

        def validate_captcha #:nodoc:
          errors.add(:captcha_solution, :blank) and return if captcha_solution.blank?
          errors.add(:captcha_solution, :invalid) unless captcha_valid?
        end

        def captcha_valid? #:nodoc:
          ValidatesCaptcha.provider.solved?(captcha_challenge, captcha_solution)
        end
    end
  end
end

