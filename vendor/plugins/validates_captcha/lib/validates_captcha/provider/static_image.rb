require 'digest/sha1'
require 'action_view/helpers'

module ValidatesCaptcha
  module Provider
    # An image captcha provider that relies on pre-created captcha images.
    #
    # There is a Rake tast for creating the captcha images:
    #
    #  rake validates_captcha:create_static_images
    #
    # This will create 3 images in #filesystem_dir. To create a
    # different number of images, provide a COUNT argument:
    #
    #  rake validates_captcha:create_static_images COUNT=50
    #
    # This class contains the getters and setters for the backend classes:
    # image generator and string generator.  This allows you to replace them
    # with your custom implementations.  For more information on how to bring
    # the image provider to use your own implementation instead of the default
    # one, consult the documentation for the specific default class.
    #
    # The default captcha image generator uses ImageMagick's +convert+ command to
    # create the captcha.  So a recent and properly configured version of ImageMagick
    # must be installed on the system.  The version used while developing was 6.4.5.
    # But you are not bound to ImageMagick.  If you want to provide a custom image
    # generator, take a look at the documentation for
    # ValidatesCaptcha::ImageGenerator::Simple on how to create your own.
    class StaticImage
      include ActionView::Helpers

      SALT = "3f(61&831_fa0712d4a?b58-eb4b8$a2%.36378f".freeze

      @@string_generator = nil
      @@image_generator = nil
      @@filesystem_dir = nil
      @@web_dir = nil
      @@salt = nil

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

        # Returns the current captcha image file system directory. Defaults to
        # +RAILS_ROOT/public/images/captchas+.
        def filesystem_dir
          @@filesystem_dir ||= ::File.join(::Rails.public_path, 'images', 'captchas')
        end

        # Sets the current captcha image file system directory. Used to set a custom
        # image directory.
        def filesystem_dir=(dir)
          @@filesystem_dir = dir
        end

        # Returns the current captcha image web directory. Defaults to
        # +/images/captchas+.
        def web_dir
          @@web_dir ||= '/images/captchas'
        end

        # Sets the current captcha image web directory. Used to set a custom
        # image directory.
        def web_dir=(dir)
          @@web_dir = dir
        end

        # Returns the current salt used for encryption.
        def salt
          @@salt ||= SALT
        end

        # Sets the current salt used for encryption. Used to set a custom
        # salt.
        def salt=(salt)
          @@salt = salt
        end

        # Return the encryption of the +code+ using #salt.
        def encrypt(code)
          ::Digest::SHA1.hexdigest "#{salt}--#{code}"
        end

        # Creates a captcha image in the #filesystem_dir and returns
        # the path to it and the code displayed on the image.
        def create_image
          code = string_generator.generate
          encrypted_code = encrypt(code)

          image_filename = "#{encrypted_code}#{image_generator.file_extension}"
          image_path = File.join(filesystem_dir, image_filename)
          image_bytes = image_generator.generate(code)

          File.open image_path, 'w' do |os|
            os.write image_bytes
          end

          return image_path, code
        end
      end

      # This method is the one called by Rack.
      #
      # It returns HTTP status 404 if the path is not recognized. If the path is
      # recognized, it returns HTTP status 200 and delivers a new challenge in
      # JSON format.
      #
      # Please take a look at the source code if you want to learn more.
      def call(env)
        if env['PATH_INFO'] == regenerate_path
          captcha_challenge = generate_challenge
          json = { :captcha_challenge => captcha_challenge, :captcha_image_path => image_path(captcha_challenge) }.to_json

          [200, { 'Content-Type' => 'application/json' }, [json]]
        else
          [404, { 'Content-Type' => 'text/html' }, ['Not Found']]
        end
      end

      # Returns an array containing the paths to the available captcha images.
      def images
        @images ||= Dir[File.join(filesystem_dir, "*#{image_file_extension}")]
      end

      # Returns an array containing the available challenges (encrypted captcha codes).
      def challenges
        @challenges ||= images.map { |path| File.basename(path, image_file_extension) }
      end

      # Returns a captcha challenge.
      def generate_challenge
        raise("no captcha images found in #{filesystem_dir}") if challenges.empty?

        challenges[rand(challenges.size)]
      end

      # Returns true if the captcha was solved using the given +challenge+ and +solution+,
      # otherwise false.
      def solved?(challenge, solution)
        challenge == encrypt(solution)
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
        def regenerate_path #:nodoc:
          '/captchas/regenerate'
        end

        def image_file_extension #:nodoc:
          self.class.image_generator.file_extension
        end

        def image_path(encrypted_code) #:nodoc:
          File.join(web_dir, "#{encrypted_code}#{image_file_extension}")
        end

        def encrypt(code) #:nodoc:
          self.class.encrypt code
        end

        def filesystem_dir #:nodoc:
          self.class.filesystem_dir
        end

        def web_dir #:nodoc:
          self.class.web_dir
        end

        # This is needed by +link_to_remote+ called in +render_regenerate_link+.
        def protect_against_forgery? #:nodoc:
          false
        end
    end
  end
end

