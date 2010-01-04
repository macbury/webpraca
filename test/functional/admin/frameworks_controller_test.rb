require 'test_helper'

class Admin::FrameworksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_frameworks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create framework" do
    assert_difference('Admin::Framework.count') do
      post :create, :framework => { }
    end

    assert_redirected_to framework_path(assigns(:framework))
  end

  test "should show framework" do
    get :show, :id => admin_frameworks(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_frameworks(:one).to_param
    assert_response :success
  end

  test "should update framework" do
    put :update, :id => admin_frameworks(:one).to_param, :framework => { }
    assert_redirected_to framework_path(assigns(:framework))
  end

  test "should destroy framework" do
    assert_difference('Admin::Framework.count', -1) do
      delete :destroy, :id => admin_frameworks(:one).to_param
    end

    assert_redirected_to admin_frameworks_path
  end
end
