module ValidatesCaptcha
  module FormBuilder #:nodoc:
    def captcha_challenge(options = {}) #:nodoc:
      @template.captcha_challenge @object_name, options.merge(:object => @object)
    end

    def captcha_field(options = {}) #:nodoc:
      @template.captcha_field @object_name, options.merge(:object => @object)
    end

    def regenerate_captcha_challenge_link(options = {}, html_options = {}) #:nodoc:
      @template.regenerate_captcha_challenge_link @object_name, options.merge(:object => @object), html_options
    end
  end
end

