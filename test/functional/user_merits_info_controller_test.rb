require 'test_helper'

class UserMeritsInfoControllerTest < ActionController::TestCase
  test "should get update_closed" do
    get :update_closed
    assert_response :success
  end

end
