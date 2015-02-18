require 'test_helper'

class MessageboxControllerTest < ActionController::TestCase
  test "should get outbox" do
    get :outbox
    assert_response :success
  end

  test "should get inbox" do
    get :inbox
    assert_response :success
  end

end
