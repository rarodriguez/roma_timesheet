require 'test_helper'

class HoursControllerTest < ActionController::TestCase
  setup do
    @hour = hours(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hour" do
    assert_difference('Hour.count') do
      post :create, :hour => @hour.attributes
    end

    assert_redirected_to hour_path(assigns(:hour))
  end

  test "should show hour" do
    get :show, :id => @hour.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @hour.to_param
    assert_response :success
  end

  test "should update hour" do
    put :update, :id => @hour.to_param, :hour => @hour.attributes
    assert_redirected_to hour_path(assigns(:hour))
  end

  test "should destroy hour" do
    assert_difference('Hour.count', -1) do
      delete :destroy, :id => @hour.to_param
    end

    assert_redirected_to hours_path
  end
end
