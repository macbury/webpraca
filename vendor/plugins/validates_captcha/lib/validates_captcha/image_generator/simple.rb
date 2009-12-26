module ValidatesCaptcha
  module ImageGenerator
    # This class is responsible for creating the captcha image. It internally
    # uses ImageMagick's +convert+ command to generate the image bytes. So
    # ImageMagick must be installed on the system for it to work properly.
    #
    # In order to deliver the captcha image to the user's browser,
    # Validate Captcha's Rack middleware calls the methods of this class
    # to create the image, to retrieve its mime type, and to construct the
    # path to it.
    #
    # The image generation process is no rocket science. The chars are just
    # laid out next to each other with varying vertical positions, font sizes,
    # and weights. Then a slight rotation is performed and some randomly
    # positioned lines are rendered on the canvas.
    #
    # Sure, the created captcha can easily be cracked by intelligent
    # bots. As the name of the class suggests, it's rather a starting point
    # for your own implementations.
    #
    # You can implement your own (better) image generator by creating a
    # class that conforms to the method definitions of the example below.
    #
    # Example for a custom image generator:
    #
    #  class AdvancedImageGenerator
    #    def generate(captcha_text)
    #      # ... do your magic here ...
    #
    #      return string_containing_image_bytes
    #    end
    #
    #    def mime_type
    #      'image/png'
    #    end
    #
    #    def file_extension
    #      '.png'
    #    end
    #  end
    #
    # Then assign an instance of it to ValidatesCaptcha::Provider::DynamicImage#image_generator=.
    #
    #  ValidatesCaptcha::Provider::DynamicImage.image_generator = AdvancedImageGenerator.new
    #  ValidatesCaptcha.provider = ValidatesCaptcha::Provider::DynamicImage.new
    #
    # Or to ValidatesCaptcha::Provider::StaticImage#image_generator=.
    #
    #  ValidatesCaptcha::Provider::StaticImage.image_generator = AdvancedImageGenerator.new
    #  ValidatesCaptcha.provider = ValidatesCaptcha::Provider::StaticImage.new
    #
    class Simple
      MIME_TYPE = 'image/gif'.freeze
      FILE_EXTENSION = '.gif'.freeze

      # Returns a string containing the image bytes of the captcha.
      # As the only argument, the cleartext captcha text must be passed.
      def generate(captcha_code)
        image_width = captcha_code.length * 20 + 10

        cmd = []
        cmd << "convert -size #{image_width}x40 xc:grey84 -background grey84 -fill black "

        captcha_code.split(//).each_with_index do |char, i|
          cmd << " -pointsize #{rand(8) + 15} "
          cmd << " -weight #{rand(2) == 0 ? '4' : '8'}00 "
          cmd << " -draw 'text #{5 + 20 * i},#{rand(10) + 20} \"#{char}\"' "
        end

        cmd << "  -rotate #{rand(2) == 0 ? '-' : ''}5 -fill grey40 "

        captcha_code.size.times do
          cmd << "  -draw 'line #{rand(image_width)},0 #{rand(image_width)},60' "
        end

        cmd << "  gif:-"

        image_magick_command = cmd.join

        `#{image_magick_command}`
      end

      # Returns the image mime type. This is always 'image/gif'.
      def mime_type
        MIME_TYPE
      end

      # Returns the image file extension. This is always '.gif'.
      def file_extension
        FILE_EXTENSION
      end
    end
  end
end

