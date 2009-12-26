require 'test_helper'

class ModelValidationTest < ValidatesCaptcha::TestCase
  def with_dynamic_image_provider(&block)
    old_provider = ValidatesCaptcha.provider
    provider = ValidatesCaptcha.provider = ValidatesCaptcha::Provider::DynamicImage.new
    yield provider
    ValidatesCaptcha.provider = old_provider
  end

  def with_static_image_provider(&block)
    old_provider = ValidatesCaptcha.provider
    provider = ValidatesCaptcha.provider = ValidatesCaptcha::Provider::StaticImage.new
    provider.instance_variable_set "@images", ["/path/to/#{provider.send(:encrypt, 'hello')}#{provider.send(:image_file_extension)}"]
    yield provider
    ValidatesCaptcha.provider = old_provider
  end

  def with_question_provider(&block)
    old_provider = ValidatesCaptcha.provider
    provider = ValidatesCaptcha.provider = ValidatesCaptcha::Provider::Question.new
    yield provider
    ValidatesCaptcha.provider = old_provider
  end

  test "defines an instance level #captcha_solution method" do
    assert_respond_to Widget.new, :captcha_solution
  end

  test "defines a instance level #captcha_solution= method" do
    assert_respond_to Widget.new, :captcha_solution=
  end

  test "assigned value to #captcha_solution= should equal return value of #captcha_solution" do
    widget = Widget.new
    widget.captcha_solution = 'abc123'

    assert_equal 'abc123', widget.captcha_solution
  end

  test "defines an instance level #captcha_challenge method" do
    assert_respond_to Widget.new, :captcha_challenge
  end

  test "defines an instance level #captcha_challenge= method" do
    assert_respond_to Widget.new, :captcha_challenge=
  end

  test "value assigned to #captcha_challenge= should equal return value of #captcha_challenge" do
    widget = Widget.new
    widget.captcha_challenge = 'asdfghjk3456789'

    assert_equal 'asdfghjk3456789', widget.captcha_challenge
  end

  test "should not add captcha_challenge as attr_accessible" do
    assert !(Widget.accessible_attributes || []).include?('captcha_challenge')
  end

  test "should not add captcha_solution as attr_accessible" do
    assert !(Widget.accessible_attributes || []).include?('captcha_solution')
  end

  test "should also assign non-attr_accessible captcha fields when mass assigning attributes" do
    widget = Widget.new

    widget.attributes = { :name => 'foo', :captcha_challenge => 'bar', :captcha_solution => 'baz' }
    assert_equal 'foo', widget.name
    assert_equal 'bar', widget.captcha_challenge
    assert_equal 'baz', widget.captcha_solution

    widget.attributes = { 'name' => 'bar', 'captcha_challenge' => 'baz', 'captcha_solution' => 'foo' }
    assert_equal 'bar', widget.name
    assert_equal 'baz', widget.captcha_challenge
    assert_equal 'foo', widget.captcha_solution
  end

  test "defines #validate_captcha method callback of kind +validate+" do
    assert Widget.validate_callback_chain.any? { |callback| callback.method == :validate_captcha && callback.kind == :validate }
  end

  test "defines a class level with_captcha_validation method" do
    assert_respond_to Widget, :with_captcha_validation
  end

  test "not within a #with_captcha_validation block, calling valid? should return true if no captcha_solution is set" do
    widget = Widget.new
    widget.captcha_solution = nil

    assert widget.valid?
  end

  test "not within a #with_captcha_validation block, calling valid? should return true if an empty captcha_solution is set" do
    widget = Widget.new
    widget.captcha_solution = '   '

    assert widget.valid?
  end

  test "not within a #with_captcha_validation block, calling valid? should return true if an invalid captcha_solution is set" do
    with_dynamic_image_provider do |provider|
      widget = Widget.new
      widget.captcha_solution = provider.send(:decrypt, widget.captcha_challenge).reverse

      assert widget.valid?
    end

    with_static_image_provider do |provider|
      widget = Widget.new
      widget.captcha_solution = '---'

      assert widget.valid?
    end

    with_question_provider do |provider|
      widget = Widget.new
      widget.captcha_solution = '---'

      assert widget.valid?
    end
  end

  test "not within a #with_captcha_validation block, calling valid? should return true if a valid captcha_solution is set" do
    with_dynamic_image_provider do |provider|
      widget = Widget.new
      widget.captcha_solution = provider.send(:decrypt, widget.captcha_challenge)

      assert widget.valid?
    end

    with_static_image_provider do |provider|
      widget = Widget.new
      widget.captcha_solution = 'hello'

      assert widget.valid?
    end

    with_question_provider do |provider|
      widget = Widget.new
      widget.captcha_solution = provider.send(:solve, widget.captcha_challenge)

      assert widget.valid?
    end
  end

  test "within a #with_captcha_validation block, calling valid? should return false if no captcha_solution is set" do
    Widget.with_captcha_validation do
      widget = Widget.new
      widget.captcha_solution = nil

      assert !widget.valid?
      assert_equal 1, Array.wrap(widget.errors[:captcha_solution]).size
      assert Array.wrap(widget.errors[:captcha_solution]).first.include?('blank')
    end
  end

  test "within a #with_captcha_validation block, calling valid? should return false if an empty captcha_solution is set" do
    Widget.with_captcha_validation do
      widget = Widget.new
      widget.captcha_solution = '   '

      assert !widget.valid?
      assert_equal 1, Array.wrap(widget.errors[:captcha_solution]).size
      assert Array.wrap(widget.errors[:captcha_solution]).first.include?('blank')
    end
  end

  test "within a #with_captcha_validation block, calling valid? should return false if an invalid captcha_solution is set" do
    with_dynamic_image_provider do |provider|
      Widget.with_captcha_validation do
        widget = Widget.new
        widget.captcha_solution = provider.send(:decrypt, widget.captcha_challenge).reverse

        assert !widget.valid?
        assert_equal 1, Array.wrap(widget.errors[:captcha_solution]).size
        assert Array.wrap(widget.errors[:captcha_solution]).first.include?('invalid')
      end
    end

    with_static_image_provider do |provider|
      Widget.with_captcha_validation do
        widget = Widget.new
        widget.captcha_solution = '---'

        assert !widget.valid?
        assert_equal 1, Array.wrap(widget.errors[:captcha_solution]).size
        assert Array.wrap(widget.errors[:captcha_solution]).first.include?('invalid')
      end
    end

    with_question_provider do |provider|
      Widget.with_captcha_validation do
        widget = Widget.new
        widget.captcha_solution = '---'

        assert !widget.valid?
        assert_equal 1, Array.wrap(widget.errors[:captcha_solution]).size
        assert Array.wrap(widget.errors[:captcha_solution]).first.include?('invalid')
      end
    end
  end

  test "within a #with_captcha_validation block, calling valid? should return true if a valid captcha_solution is set" do
    with_dynamic_image_provider do |provider|
      Widget.with_captcha_validation do
        widget = Widget.new
        widget.captcha_solution = provider.send(:decrypt, widget.captcha_challenge)

        assert widget.valid?
      end
    end

    with_static_image_provider do |provider|
      Widget.with_captcha_validation do
        widget = Widget.new
        widget.captcha_solution = 'hello'

        assert widget.valid?
      end
    end

    with_question_provider do |provider|
      Widget.with_captcha_validation do
        widget = Widget.new
        widget.captcha_solution = provider.send(:solve, widget.captcha_challenge)

        assert widget.valid?
      end
    end
  end

  test "with #with_captcha_validation block, calling valid? before and after the block should return true if valid? returned false within block" do
    with_dynamic_image_provider do |provider|
      widget = Widget.new
      widget.captcha_solution = provider.send(:decrypt, widget.captcha_challenge).reverse

      assert widget.valid?

      Widget.with_captcha_validation do
        assert !widget.valid?
      end

      assert widget.valid?
    end

    with_static_image_provider do |provider|
      widget = Widget.new
      widget.captcha_solution = '---'

      assert widget.valid?

      Widget.with_captcha_validation do
        assert !widget.valid?
      end

      assert widget.valid?
    end

    with_question_provider do |provider|
      widget = Widget.new
      widget.captcha_solution = '---'

      assert widget.valid?

      Widget.with_captcha_validation do
        assert !widget.valid?
      end

      assert widget.valid?
    end
  end
end

