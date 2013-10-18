require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get adminhome" do
    get :adminhome
    assert_response :success
  end

end
