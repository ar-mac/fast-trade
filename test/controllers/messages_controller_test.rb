require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:tom)
    @user2 = users(:bob)
    @offer2 = @user2.offers.first
    @message = messages(:one)
    @issue = @message.issue
  end
  
  test "should get new" do
    log_in_as @user
    get :new, offer_id: @offer2
    assert_response :success
  end

end
