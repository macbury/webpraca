require 'test_helper'

IG = ValidatesCaptcha::ImageGenerator::Simple

class ImageGeneratorTest < ValidatesCaptcha::TestCase
  test "defines an instance level #generate method" do
    assert_respond_to IG.new, :generate
  end

  test "instance level #generate method accepts an argument" do
    assert_nothing_raised { IG.new.generate('abc') }
  end

  test "instance level #generate method returns a string" do
    assert_kind_of String, IG.new.generate('abc')
  end

  test "defines an instance level #file_extension method" do
    assert_respond_to IG.new, :file_extension
  end

  test "instance level #file_extension method returns a string" do
    assert_kind_of String, IG.new.file_extension
  end

  test "defines an instance level #mime_type method" do
    assert_respond_to IG.new, :mime_type
  end

  test "instance level #mime_type method returns a string" do
    assert_kind_of String, IG.new.mime_type
  end
end

