module ValidatesCaptcha
  module StringGenerator
    # This class is responsible for generating the codes that are displayed
    # on the captcha images. It does so by randomly selecting a number of
    # characters from a predefined alphabet constisting of visually distinguishable
    # letters and digits.
    #
    # The number of characters and the alphabet used when generating strings can
    # be customized. See the #alphabet= and #length= methods for details.
    #
    # You can implement your own string generator by creating a
    # class that conforms to the method definitions of the example below and
    # assign an instance of it to
    # ValidatesCaptcha::Provider::DynamicImage#string_generator=.
    #
    # Example for a custom string generator:
    #
    #  class DictionaryGenerator
    #    DICTIONARY = ['foo', 'bar', 'baz', ...]
    #
    #    def generate
    #      return DICTIONARY[rand(DICTIONARY.size)]
    #    end
    #  end
    #
    #  ValidatesCaptcha::Provider::DynamicImage.string_generator = DictionaryGenerator.new
    #  ValidatesCaptcha.provider = ValidatesCaptcha::Provider::DynamicImage.new
    #
    # You can also assign it to ValidatesCaptcha::Provider::StaticImage#string_generator=.
    #
    class Simple
      @@alphabet = 'abdefghjkmnqrtABDEFGHJKLMNQRT234678923467892346789'
      @@length = 6

      class << self
        # Returns a string holding the chars used when randomly generating the text that
        # is displayed on a captcha image. Defaults to a string of visually distinguishable
        # letters and digits.
        def alphabet
          @@alphabet
        end

        # Sets the string to use as alphabet when randomly generating the text displayed
        # on a captcha image. To increase the probability of appearing in the image, some
        # characters might appear more than once in the string.
        #
        # You can set this to a custom alphabet within a Rails initializer:
        #
        #  ValidatesCaptcha::StringGenerator::Simple.alphabet = '01'
        def alphabet=(alphabet)
          alphabet = alphabet.to_s.gsub(/\s/, '')
          raise('alphabet cannot be blank') if alphabet.blank?

          @@alphabet = alphabet
        end

        # Returns the length to use when generating captcha codes. Defaults to 6.
        def length
          @@length
        end

        # Sets the length to use when generating captcha codes.
        #
        # You can set this to a custom length within a Rails initializer:
        #
        #  ValidatesCaptcha::StringGenerator::Simple.length = 8
        def length=(length)
          @@length = length.to_i
        end
      end

      # Randomly generates a string to be used as the code displayed on captcha images.
      def generate
        alphabet_chars = self.class.alphabet.split(//)
        code_chars = []
        self.class.length.times { code_chars << alphabet_chars[rand(alphabet_chars.size)] }
        code_chars.join
      end
    end
  end
end

