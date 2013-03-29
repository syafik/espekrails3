require 'test_helper'

class ExcecutivesControllerTest < ActionController::TestCase
  test "should get analysis" do
    get :analysis
    assert_response :success
  end

  test "should get achievement" do
    get :achievement
    assert_response :success
  end

  test "should get feedback" do
    get :feedback
    assert_response :success
  end

  test "should get implementation" do
    get :implementation
    assert_response :success
  end

  test "should get realization" do
    get :realization
    assert_response :success
  end

end
