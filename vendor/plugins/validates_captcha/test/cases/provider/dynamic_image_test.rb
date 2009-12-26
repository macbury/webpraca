require 'test_helper'

IMAGE = ValidatesCaptcha::Provider::DynamicImage

class DynamicImageTest < ValidatesCaptcha::TestCase
  test "defines a class level #string_generator method" do
    assert_respond_to IMAGE, :string_generator
  end

  test "defines a class level #string_generator= method" do
    assert_respond_to IMAGE, :string_generator=
  end

  test "#string_generator method's return value should equal the value set using the #string_generator= method" do
    old_string_generator = IMAGE.string_generator

    IMAGE.string_generator = 'abc'
    assert_equal 'abc', IMAGE.string_generator

    IMAGE.string_generator = old_string_generator
  end

  test "defines a class level #symmetric_encryptor method" do
    assert_respond_to IMAGE, :symmetric_encryptor
  end

  test "defines a class level #symmetric_encryptor= method" do
    assert_respond_to IMAGE, :symmetric_encryptor=
  end

  test "#symmetric_encryptor method's return value should equal the value set using the #symmetric_encryptor= method" do
    old_symmetric_encryptor = IMAGE.symmetric_encryptor

    IMAGE.symmetric_encryptor = 'abc'
    assert_equal 'abc', IMAGE.symmetric_encryptor

    IMAGE.symmetric_encryptor = old_symmetric_encryptor
  end

  test "defines a class level #image_generator method" do
    assert_respond_to IMAGE, :image_generator
  end

  test "defines a class level #image_generator= method" do
    assert_respond_to IMAGE, :image_generator=
  end

  test "#image_generator method's return value should equal the value set using the #image_generator= method" do
    old_image_generator = IMAGE.image_generator

    IMAGE.image_generator = 'abc'
    assert_equal 'abc', IMAGE.image_generator

    IMAGE.image_generator = old_image_generator
  end

  test "calling #call with unrecognized path should have response status 404" do
    result = IMAGE.new.call 'PATH_INFO' => '/unrecognized'

    assert_equal 404, result.first
  end

  test "calling #call with recognized path should not have response status 404" do
    result = IMAGE.new.call 'PATH_INFO' => IMAGE.new.send(:image_path, 'abc123')

    assert_not_equal 404, result.first
  end

  test "calling #call with valid encrypted captcha code should have response status 200" do
    encrypted_code = IMAGE.new.generate_challenge
    result = IMAGE.new.call 'PATH_INFO' => "/captchas/#{encrypted_code}"

    assert_equal 200, result.first
  end

  test "calling #call with valid encrypted captcha code should have expected content type response header" do
    encrypted_code = IMAGE.new.generate_challenge
    result = IMAGE.new.call 'PATH_INFO' => "/captchas/#{encrypted_code}"

    assert result.second.key?('Content-Type')
    assert_equal IMAGE.image_generator.mime_type, result.second['Content-Type']
  end

  test "calling #call with invalid encrypted captcha code should have response status 422" do
    encrypted_code = IMAGE.new.generate_challenge.reverse
    result = IMAGE.new.call 'PATH_INFO' => "/captchas/#{encrypted_code}"

    assert_equal 422, result.first
  end

  test "calling #call with regenerate path should have response status 200" do
    result = IMAGE.new.call 'PATH_INFO' => IMAGE.new.send(:regenerate_path)

    assert_equal 200, result.first
  end

  test "calling #call with regenerate path should have content type response header set to application/json" do
    result = IMAGE.new.call 'PATH_INFO' => IMAGE.new.send(:regenerate_path)

    assert result.second.key?('Content-Type')
    assert_equal 'application/json', result.second['Content-Type']
  end
end

