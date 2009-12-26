module ValidatesCaptcha
  module FormHelper
    # Returns the captcha challenge.
    #
    # Internally calls the +render_challenge+ method of ValidatesCaptcha#provider.
    def captcha_challenge(object_name, options = {})
      options.symbolize_keys!

      object = options.delete(:object)
      sanitized_object_name = object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")

      ValidatesCaptcha.provider.render_challenge sanitized_object_name, object, options
    end

    # Returns an input tag of the "text" type tailored for entering the captcha solution.
    #
    # Internally calls Rails' #text_field helper method, passing the +object_name+ and
    # +options+ arguments.
    def captcha_field(object_name, options = {})
      options.delete(:id)

      hidden_field(object_name, :captcha_challenge, options) + text_field(object_name, :captcha_solution, options)
    end

    # By default, returns an anchor tag that makes an AJAX request to fetch a new captcha challenge and updates
    # the current challenge after the request is complete.
    #
    # Internally calls +render_regenerate_challenge_link+ method of ValidatesCaptcha#provider.
    def regenerate_captcha_challenge_link(object_name, options = {}, html_options = {})
      options.symbolize_keys!

      object = options.delete(:object)
      sanitized_object_name = object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")

      ValidatesCaptcha.provider.render_regenerate_challenge_link sanitized_object_name, object, options, html_options
    end
  end
end

