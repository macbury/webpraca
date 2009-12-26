require 'test_helper'

class ValidatesCaptchaTest < ValidatesCaptcha::TestCase
  test "defines a class level #version method" do
    assert_respond_to ValidatesCaptcha, :version
  end

  test "class level #version method returns a valid version" do
    assert_match /^\d+\.\d+\.\w+$/, ValidatesCaptcha.version
  end

  test "defines a class level #provider method" do
    assert_respond_to ValidatesCaptcha, :provider
  end

  test "defines a class level #provider= method" do
    assert_respond_to ValidatesCaptcha, :provider=
  end

  test "#provider method's return value should equal the value set using the #provider= method" do
    old_provider = ValidatesCaptcha.provider

    ValidatesCaptcha.provider = 'abc'
    assert_equal 'abc', ValidatesCaptcha.provider

    ValidatesCaptcha.provider = old_provider
  end
end

