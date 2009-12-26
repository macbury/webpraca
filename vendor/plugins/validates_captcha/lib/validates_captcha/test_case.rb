require 'active_support/test_case'

module ValidatesCaptcha #:nodoc:
  class TestCase < ActiveSupport::TestCase #:nodoc:
    def assert_greater_than(expected, size, message = '')
      _wrap_assertion do
        full_message = build_message(message, "<?> expected to be greater than <?>.", size, expected)
        assert_block(full_message) { size > expected }
      end
    end
  end
end

