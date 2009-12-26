require 'test_helper'

SG = ValidatesCaptcha::StringGenerator::Simple

class StringGeneratorTest < ValidatesCaptcha::TestCase
  test "defines a class level #alphabet method" do
    assert_respond_to SG, :alphabet
  end

  test "class level #alphabet method returns a string" do
    assert_kind_of String, SG.alphabet
    assert_greater_than 0, SG.alphabet.length
  end

  test "defines a class level #alphabet= method" do
    assert_respond_to SG, :alphabet=
  end

  test "#alphabet method's return value should equal the value set using the #alphabet= method" do
    old_alphabet = SG.alphabet

    SG.alphabet = 'abc'
    assert_equal 'abc', SG.alphabet

    SG.alphabet = old_alphabet
  end

  test "#alphabet= method converts supplied value to a string" do
    old_alphabet = SG.alphabet

    [:abc, 123, %w(x y z)].each do |value|
      SG.alphabet = value
      assert_equal value.to_s, SG.alphabet
    end

    SG.alphabet = old_alphabet
  end

  test "#alphabet= method removes whitespace from supplied value" do
    old_alphabet = SG.alphabet

    SG.alphabet = " abc    d ef\n"
    assert_equal "abcdef", SG.alphabet

    SG.alphabet = old_alphabet
  end

  test "#alphabet= method raises error if supplied value is blank" do
    assert_raise RuntimeError do
      SG.alphabet = ''
    end
  end

  test "defines a class level #length method" do
    assert_respond_to SG, :length
  end

  test "class level #length method returns a number" do
    assert_kind_of Fixnum, SG.length
  end

  test "defines a class level #length= method" do
    assert_respond_to SG, :length=
  end

  test "#length method's return value should equal the value set using the #length= method" do
    old_length = SG.length

    SG.length = 42
    assert_equal 42, SG.length

    SG.length = old_length
  end

  test "defines an instance level #generate method" do
    assert_respond_to SG.new, :generate
  end

  test "instance level #generate method returns a string" do
    assert_kind_of String, SG.new.generate
  end

  test "calling #generate should return a string of #length size" do
    10.times do
      assert_equal SG.length, SG.new.generate.length
    end
  end

  test "calling #generate with custom set #length should return a string of #length size" do
    old_length = SG.length
    SG.length = 42

    10.times do
      assert_equal 42, SG.new.generate.length
    end

    SG.length = old_length
  end

  test "string returned from #generate should only contain chars from #alphabet" do
    old_alphabet = SG.alphabet
    old_length = SG.length

    SG.alphabet = 'Abc123'
    SG.length = 1000
    generated = SG.new.generate

    assert generated.tr('Abc123', '      ').blank?
    assert !generated.tr('abc123', '      ').blank?

    SG.length = old_length
    SG.alphabet = old_alphabet
  end
end

