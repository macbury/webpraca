require 'active_support'

module ValidatesCaptcha
  module SymmetricEncryptor
    # This class is responsible for encrypting and decrypting captcha codes.
    # It internally uses ActiveSupport's MessageEncryptor to do the string
    # encryption/decryption.
    #
    # You can implement your own symmetric encryptor by creating a class
    # that conforms to the method definitions of the example below and
    # assign an instance of it to
    # ValidatesCaptcha::Provider::DynamicImage#symmetric_encryptor=.
    #
    # Example for a custom symmetric encryptor:
    #
    #  class ReverseString # very insecure and easily cracked
    #    def encrypt(code)
    #      code.reverse
    #    end
    #
    #    def decrypt(encrypted_code)
    #      encrypted_code.reverse
    #    rescue SomeKindOfDecryptionError
    #      nil
    #    end
    #  end
    #
    #  ValidatesCaptcha::Provider::DynamicImage.symmetric_encryptor = ReverseString.new
    #  ValidatesCaptcha.provider = ValidatesCaptcha::Provider::DynamicImage.new
    #
    # Please note: The #decrypt method should return +nil+ if decryption fails.
    class Simple
      KEY = ::ActiveSupport::SecureRandom.hex(64).freeze

      def initialize #:nodoc:
        @symmetric_encryptor = ::ActiveSupport::MessageEncryptor.new(KEY)
      end

      # Encrypts a cleartext string.
      def encrypt(code)
        @symmetric_encryptor.encrypt(code).gsub('+', '%2B').gsub('/', '%2F')
      end

      # Decrypts an encrypted string.
      def decrypt(encrypted_code)
        @symmetric_encryptor.decrypt encrypted_code.gsub('%2F', '/').gsub('%2B', '+')
      rescue ::ActiveSupport::MessageEncryptor::InvalidMessage
        nil
      end
    end
  end
end

