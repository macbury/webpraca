require 'validates_captcha'

config.after_initialize do
  ::ActiveRecord::Base.send :include, ValidatesCaptcha::ModelValidation
  ::ActionController::Base.send :include, ValidatesCaptcha::ControllerValidation
  ::ActionView::Base.send :include, ValidatesCaptcha::FormHelper
  ::ActionView::Helpers::FormBuilder.send :include, ValidatesCaptcha::FormBuilder
end

module ::ValidatesCaptcha
  class MiddlewareWrapper
    RECOGNIZED_RESPONSE_STATUS_CODES = [200, 422].freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      result = ValidatesCaptcha.provider.call(env)

      return @app.call(env) unless RECOGNIZED_RESPONSE_STATUS_CODES.include?(result.first)

      result
    end
  end
end

config.middleware.use ::ValidatesCaptcha::MiddlewareWrapper

