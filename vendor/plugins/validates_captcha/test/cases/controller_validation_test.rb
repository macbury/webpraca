require 'test_helper'
require 'action_controller'

ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id'
end

class WidgetsController < ActionController::Base
  include ValidatesCaptcha::ControllerValidation

  validates_captcha :except => [:update, :save, :persist, :bingo]
  validates_captcha_of :widgets, :only => :update
  validates_captcha_of Widget, :only => [:save, :persist]

  def create
    begin
      Widget.new.save!
    rescue ActiveRecord::RecordInvalid
      @invalid = true
    end

    render :nothing => true
  end

  def update
    begin
      Widget.new.save!
    rescue ActiveRecord::RecordInvalid
      @invalid = true
    end

    render :nothing => true
  end

  def save
    begin
      Widget.create! params['widget']
    rescue ActiveRecord::RecordInvalid
      @invalid = true
    end

    render :nothing => true
  end

  def store
    begin
      Widget.create! params['widget']
    rescue ActiveRecord::RecordInvalid
      @invalid = true
    end

    render :nothing => true
  end

  def persist
    begin
      Widget.create! params['widget']
    rescue ActiveRecord::RecordInvalid
      @invalid = true
    end

    render :nothing => true
  end

  def bingo
    begin
      Widget.new.save!
    rescue ActiveRecord::RecordInvalid
      @invalid = true
    end

    render :nothing => true
  end
end

class ControllerValidationTest < ActionController::TestCase
  tests WidgetsController

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

  test "defines a class level #validates_captcha method" do
    assert_respond_to WidgetsController, :validates_captcha
  end

  test "defines a class level #validates_captcha_of method" do
    assert_respond_to WidgetsController, :validates_captcha_of
  end

  test "calling #create method of controller should assign @invalid" do
    post :create
    assert_not_nil assigns(:invalid)
  end

  test "calling #update method of controller should assign @invalid" do
    post :update
    assert_not_nil assigns(:invalid)
  end

  test "calling #save method of controller should not assign @invalid" do
    with_dynamic_image_provider do |provider|
      challenge = provider.generate_challenge
      solution = provider.send(:decrypt, challenge)

      post :save, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_nil assigns(:invalid)
    end

    with_static_image_provider do |provider|
      challenge = provider.generate_challenge
      solution = 'hello'

      post :save, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_nil assigns(:invalid)
    end

    with_question_provider do |provider|
      challenge = provider.generate_challenge
      solution = provider.send(:solve, challenge)

      post :save, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_nil assigns(:invalid)
    end
  end

  test "calling #store method of controller should assign @invalid" do
    with_dynamic_image_provider do |provider|
      challenge = provider.generate_challenge
      solution = provider.send(:decrypt, challenge).reverse

      post :store, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_not_nil assigns(:invalid)
    end

    with_static_image_provider do |provider|
      challenge = provider.generate_challenge
      solution = '---'

      post :store, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_not_nil assigns(:invalid)
    end

    with_question_provider do |provider|
      challenge = provider.generate_challenge
      solution = '---'

      post :store, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_not_nil assigns(:invalid)
    end
  end

  test "calling #persist method of controller should assign @invalid" do
    with_dynamic_image_provider do |provider|
      challenge = provider.generate_challenge
      solution = provider.send(:decrypt, challenge).reverse

      post :persist, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_not_nil assigns(:invalid)
    end

    with_static_image_provider do |provider|
      challenge = provider.generate_challenge
      solution = '---'

      post :persist, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_not_nil assigns(:invalid)
    end

    with_question_provider do |provider|
      challenge = provider.generate_challenge
      solution = '---'

      post :persist, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_not_nil assigns(:invalid)
    end
  end

  test "calling #bingo method of controller should not assign @invalid" do
    with_dynamic_image_provider do |provider|
      challenge = provider.generate_challenge
      solution = provider.send(:decrypt, challenge).reverse

      post :bingo, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_nil assigns(:invalid)
    end

    with_static_image_provider do |provider|
      challenge = provider.generate_challenge
      solution = '---'

      post :bingo, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_nil assigns(:invalid)
    end

    with_question_provider do |provider|
      challenge = provider.generate_challenge
      solution = '---'

      post :bingo, { 'widget' => { 'captcha_challenge' => challenge, 'captcha_solution' => solution } }
      assert_nil assigns(:invalid)
    end
  end
end

