#--
# Copyright (c) 2009 Martin Andert
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++


# This module contains the getter and setter for the captcha provider.
# This allows you to replace it with your custom implementation. For more
# information on how to bring Validates Captcha to use your own
# implementation instead of the default one, consult the documentation
# for the default provider.
module ValidatesCaptcha
  autoload :ModelValidation, 'validates_captcha/model_validation'
  autoload :ControllerValidation, 'validates_captcha/controller_validation'
  autoload :FormHelper, 'validates_captcha/form_helper'
  autoload :FormBuilder, 'validates_captcha/form_builder'
  autoload :TestCase, 'validates_captcha/test_case'
  autoload :VERSION, 'validates_captcha/version'

  module Provider
    autoload :Question, 'validates_captcha/provider/question'
    autoload :DynamicImage, 'validates_captcha/provider/dynamic_image'
    autoload :StaticImage, 'validates_captcha/provider/static_image'
  end

  module StringGenerator
    autoload :Simple, 'validates_captcha/string_generator/simple'
  end

  module SymmetricEncryptor
    autoload :Simple, 'validates_captcha/symmetric_encryptor/simple'
  end

  module ImageGenerator
    autoload :Simple, 'validates_captcha/image_generator/simple'
  end

  @@provider = nil

  class << self
    # Returns Validates Captcha's current version number.
    def version
      ValidatesCaptcha::VERSION::STRING
    end

    # Returns the current captcha challenge provider. Defaults to an instance of
    # the ValidatesCaptcha::Provider::Question class.
    def provider
      @@provider ||= Provider::Question.new
    end

    # Sets the current captcha challenge provider. Used to set a custom provider.
    def provider=(provider)
      @@provider = provider
    end
  end
end

