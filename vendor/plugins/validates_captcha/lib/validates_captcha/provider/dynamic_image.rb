require 'action_view/helpers'

module ValidatesCaptcha
  # Here is how you can implement your own captcha challenge provider. Create a
  # class that conforms to the public method definitions of the example below
  # and assign an instance of it to ValidatesCaptcha#provider=.
  #
  # Example:
  #
  #  require 'action_view/helpers'
  #
  #  class ReverseProvider
  #    include ActionView::Helpers # for content_tag, link_to_remote
  #
  #    def initialize
  #      @string_generator = ValidatesCaptcha::StringGenerator::Simple.new
  #    end
  #
  #    def generate_challenge
  #      @string_generator.generate  # creates a random string
  #    end
  #
  #    def solved?(challenge, solution)
  #      challenge.reverse == solution
  #    end
  #
  #    def render_challenge(sanitized_object_name, object, options = {})
  #      options[:id] = "#{sanitized_object_name}_captcha_question"
  #
  #      content_tag :span, "What's the reverse of '#{object.captcha_challenge}'?", options
  #    end
  #
  #    def render_regenerate_challenge_link(sanitized_object_name, object, options = {}, html_options = {})
  #      text = options.delete(:text) || 'Regenerate'
  #      on_success = "var result = request.responseJSON; " \\
  #                   "$('#{sanitized_object_name}_captcha_question').update(result.question); " \\
  #                   "$('#{sanitized_object_name}_captcha_challenge').value = result.challenge; " \\
  #                   "$('#{sanitized_object_name}_captcha_solution').value = '';"
  #
  #      link_to_remote text, options.reverse_merge(:url => '/captchas/regenerate', :method => :get, :success => success), html_options
  #    end
  #
  #    def call(env)  # this is executed by Rack
  #      if env['PATH_INFO'] == '/captchas/regenerate'
  #        challenge = generate_challenge
  #        json = { :question => "What's the reverse of '#{challenge}'?", :challenge => challenge }.to_json
  #
  #        [200, { 'Content-Type' => 'application/json' }, [json]]
  #      else
  #        [404, { 'Content-Type' => 'text/html' }, ['Not Found']]
  #      end
  #    end
  #
  #    private
  #      # Hack: This is needed by +link_to_remote+ called in +render_regenerate_challenge_link+.
  #      def protect_against_forgery?
  #        false
  #      end
  #  end
  #
  #  ValidatesCaptcha.provider = ReverseProvider.new
  module Provider
    # An image captcha provider.
    #
    # This class contains the getters and setters for the backend classes:
    # image generator, string generator, and symmetric encryptor.  This
    # allows you to replace them with your custom implementations.  For more
    # information on how to bring the image provider to use your own
    # implementation instead of the default one, consult the documentation
    # for the specific default class.
    #
    # The default captcha image generator uses ImageMagick's +convert+ command to
    # create the captcha.  So a recent and properly configured version of ImageMagick
    # must be installed on the system.  The version used while developing was 6.4.5.
    # But you are not bound to ImageMagick.  If you want to provide a custom image
    # generator, take a look at the documentation for
    # ValidatesCaptcha::ImageGenerator::Simple on how to create your own.
    class DynamicImage
      include ActionView::Helpers

      @@string_generator = nil
      @@symmetric_encryptor = nil
      @@image_generator = nil

      class << self
        # Returns the current captcha string generator. Defaults to an
        # instance of the ValidatesCaptcha::StringGenerator::Simple class.
        def string_generator
          @@string_generator ||= ValidatesCaptcha::StringGenerator::Simple.new
        end

        # Sets the current captcha string generator. Used to set a
        # custom string generator.
        def string_generator=(generator)
          @@string_generator = generator
        end

        # Returns the current captcha symmetric encryptor. Defaults to an
        # instance of the ValidatesCaptcha::SymmetricEncryptor::Simple class.
        def symmetric_encryptor
          @@symmetric_encryptor ||= ValidatesCaptcha::SymmetricEncryptor::Simple.new
        end

        # Sets the current captcha symmetric encryptor. Used to set a
        # custom symmetric encryptor.
        def symmetric_encryptor=(encryptor)
          @@symmetric_encryptor = encryptor
        end

        # Returns the current captcha image generator. Defaults to an
        # instance of the ValidatesCaptcha::ImageGenerator::Simple class.
        def image_generator
          @@image_generator ||= ValidatesCaptcha::ImageGenerator::Simple.new
        end

        # Sets the current captcha image generator. Used to set a custom
        # image generator.
        def image_generator=(generator)
          @@image_generator = generator
        end
      end

      # This method is the one called by Rack.
      #
      # It returns HTTP status 404 if the path is not recognized. If the path is
      # recognized, it returns HTTP status 200 and delivers the image if it could
      # successfully decrypt the captcha code, otherwise HTTP status 422.
      #
      # Please take a look at the source code if you want to learn more.
      def call(env)
        if env['PATH_INFO'] =~ /^\/captchas\/([^\.]+)/
          if $1 == 'regenerate'
            captcha_challenge = generate_challenge
            json = { :captcha_challenge => captcha_challenge, :captcha_image_path => image_path(captcha_challenge) }.to_json

            [200, { 'Content-Type' => 'application/json' }, [json]]
          else
            decrypted_code = decrypt($1)

            if decrypted_code.nil?
              [422, { 'Content-Type' => 'text/html' }, ['Unprocessable Entity']]
            else
              image_data = generate_image(decrypted_code)

              response_headers = {
                'Content-Length'            => image_data.bytesize.to_s,
                'Content-Type'              => image_mime_type,
                'Content-Disposition'       => 'inline',
                'Content-Transfer-Encoding' => 'binary',
                'Cache-Control'             => 'private'
              }

              [200, response_headers, [image_data]]
            end
          end
        else
          [404, { 'Content-Type' => 'text/html' }, ['Not Found']]
        end
      end

      # Returns a captcha challenge.
      def generate_challenge
        encrypt(generate_code)
      end

      # Returns true if the captcha was solved using the given +challenge+ and +solution+,
      # otherwise false.
      def solved?(challenge, solution)
        decrypt(challenge) == solution
      end

      # Returns an image tag with the source set to the url of the captcha image.
      #
      # Internally calls Rails' +image_tag+ helper method, passing the +options+ argument.
      def render_challenge(sanitized_object_name, object, options = {})
        src = image_path(object.captcha_challenge)

        options[:alt] ||= 'CAPTCHA'
        options[:id] = "#{sanitized_object_name}_captcha_image"

        image_tag src, options
      end

      # Returns an anchor tag that makes an AJAX request to fetch a new captcha code and updates
      # the captcha image after the request is complete.
      #
      # Internally calls Rails' +link_to_remote+ helper method, passing the +options+ and
      # +html_options+ arguments. So it relies on the Prototype javascript framework
      # to be available on the web page.
      #
      # The anchor text defaults to 'Regenerate Captcha'. You can set this to a custom value
      # providing a +:text+ key in the +options+ hash.
      def render_regenerate_challenge_link(sanitized_object_name, object, options = {}, html_options = {})
        text = options.delete(:text) || 'Regenerate Captcha'
        success = "var result = request.responseJSON; $('#{sanitized_object_name}_captcha_image').src = result.captcha_image_path; $('#{sanitized_object_name}_captcha_challenge').value = result.captcha_challenge; $('#{sanitized_object_name}_captcha_solution').value = '';"

        link_to_remote text, options.reverse_merge(:url => regenerate_path, :method => :get, :success => success), html_options
      end

      private
        def generate_image(code) #:nodoc:
          self.class.image_generator.generate code
        end

        def image_mime_type #:nodoc:
          self.class.image_generator.mime_type
        end

        def image_file_extension #:nodoc:
          self.class.image_generator.file_extension
        end

        def encrypt(code) #:nodoc:
          self.class.symmetric_encryptor.encrypt code
        end

        def decrypt(encrypted_code) #:nodoc:
          self.class.symmetric_encryptor.decrypt encrypted_code
        end

        def generate_code #:nodoc:
          self.class.string_generator.generate
        end

        def image_path(encrypted_code) #:nodoc:
          "/captchas/#{encrypted_code}#{image_file_extension}"
        end

        def regenerate_path #:nodoc:
          '/captchas/regenerate'
        end

        # This is needed by +link_to_remote+ called in +render_regenerate_link+.
        def protect_against_forgery? #:nodoc:
          false
        end
    end
  end
end

