require 'test_helper'

class ApplicantsControllerTest < ActionController::TestCase
  def test_create_invalid
    Applicant.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Applicant.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to root_url
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
end
