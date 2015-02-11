require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  
  def setup
    @message = messages(:one)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    
    get :edit, id: @message.id
    assert_response :success
  end

end
