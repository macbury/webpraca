require 'test_helper'

STATIC_IMAGE = ValidatesCaptcha::Provider::StaticImage

unless defined?(::Rails)
  module Rails
    def self.public_path
      'public'
    end
  end
end

class StaticImageTest < ValidatesCaptcha::TestCase
  test "defines a class level #string_generator method" do
    assert_respond_to STATIC_IMAGE, :string_generator
  end

  test "defines a class level #string_generator= method" do
    assert_respond_to STATIC_IMAGE, :string_generator=
  end

  test "#string_generator method's return value should equal the value set using the #string_generator= method" do
    old_string_generator = STATIC_IMAGE.string_generator

    STATIC_IMAGE.string_generator = 'abc'
    assert_equal 'abc', STATIC_IMAGE.string_generator

    STATIC_IMAGE.string_generator = old_string_generator
  end

  test "defines a class level #image_generator method" do
    assert_respond_to STATIC_IMAGE, :image_generator
  end

  test "defines a class level #image_generator= method" do
    assert_respond_to STATIC_IMAGE, :image_generator=
  end

  test "#image_generator method's return value should equal the value set using the #image_generator= method" do
    old_image_generator = STATIC_IMAGE.image_generator

    STATIC_IMAGE.image_generator = 'abc'
    assert_equal 'abc', STATIC_IMAGE.image_generator

    STATIC_IMAGE.image_generator = old_image_generator
  end

  test "defines a class level #salt method" do
    assert_respond_to STATIC_IMAGE, :salt
  end

  test "defines a class level #salt= method" do
    assert_respond_to STATIC_IMAGE, :salt=
  end

  test "#salt method's return value should equal the value set using the #salt= method" do
    old_salt = STATIC_IMAGE.salt

    STATIC_IMAGE.salt = 'abc'
    assert_equal 'abc', STATIC_IMAGE.salt

    STATIC_IMAGE.salt = old_salt
  end

  test "defines a class level #filesystem_dir method" do
    assert_respond_to STATIC_IMAGE, :filesystem_dir
  end

  test "defines a class level #filesystem_dir= method" do
    assert_respond_to STATIC_IMAGE, :filesystem_dir=
  end

  test "#filesystem_dir method's return value should equal the value set using the #filesystem_dir= method" do
    old_filesystem_dir = STATIC_IMAGE.filesystem_dir

    STATIC_IMAGE.filesystem_dir = 'abc'
    assert_equal 'abc', STATIC_IMAGE.filesystem_dir

    STATIC_IMAGE.filesystem_dir = old_filesystem_dir
  end

  test "defines a class level #web_dir method" do
    assert_respond_to STATIC_IMAGE, :web_dir
  end

  test "defines a class level #web_dir= method" do
    assert_respond_to STATIC_IMAGE, :web_dir=
  end

  test "#web_dir method's return value should equal the value set using the #web_dir= method" do
    old_web_dir = STATIC_IMAGE.web_dir

    STATIC_IMAGE.web_dir = 'abc'
    assert_equal 'abc', STATIC_IMAGE.web_dir

    STATIC_IMAGE.web_dir = old_web_dir
  end

  test "calling #call with unrecognized path should have response status 404" do
    result = STATIC_IMAGE.new.call 'PATH_INFO' => '/unrecognized'

    assert_equal 404, result.first
  end

  test "calling #call with regenerate path should have response status 200" do
    si = STATIC_IMAGE.new
    si.instance_variable_set "@challenges", ['abc']

    result = si.call 'PATH_INFO' => si.send(:regenerate_path)

    assert_equal 200, result.first
  end

  test "calling #call with regenerate path should have content type response header set to application/json" do
    si = STATIC_IMAGE.new
    si.instance_variable_set "@challenges", ['abc']

    result = si.call 'PATH_INFO' => si.send(:regenerate_path)

    assert result.second.key?('Content-Type')
    assert_equal 'application/json', result.second['Content-Type']
  end

  test "calling #generate_challenge should raise runtime error if no images are available" do
    si = STATIC_IMAGE.new
    si.instance_variable_set "@images", []

    assert_raises RuntimeError do
      si.generate_challenge
    end
  end

  test "calling #generate_challenge should not raise runtime error if an images is available" do
    si = STATIC_IMAGE.new
    si.instance_variable_set "@images", ['/path/to/an/image.gif']

    assert_nothing_raised do
      si.generate_challenge
    end
  end

  test "calling #generate_challenge should return the image file basename without extension" do
    si = STATIC_IMAGE.new
    si.instance_variable_set "@images", ["/path/to/an/captcha-image#{si.send(:image_file_extension)}"]

    assert_equal 'captcha-image', si.generate_challenge
  end
end

