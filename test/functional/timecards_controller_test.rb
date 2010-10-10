require 'test_helper'

class TimecardsControllerTest < ActionController::TestCase
  setup do
    @timecard = timecards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timecards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create timecard" do
    assert_difference('Timecard.count') do
      post :create, :timecard => @timecard.attributes
    end

    assert_redirected_to timecard_path(assigns(:timecard))
  end

  test "should show timecard" do
    get :show, :id => @timecard.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @timecard.to_param
    assert_response :success
  end

  test "should update timecard" do
    put :update, :id => @timecard.to_param, :timecard => @timecard.attributes
    assert_redirected_to timecard_path(assigns(:timecard))
  end

  test "should destroy timecard" do
    assert_difference('Timecard.count', -1) do
      delete :destroy, :id => @timecard.to_param
    end

    assert_redirected_to timecards_path
  end
end
