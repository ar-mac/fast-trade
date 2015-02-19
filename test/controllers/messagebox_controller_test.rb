require 'test_helper'

class MessageboxControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:bob)
  end
  
  test "should get box" do
    log_in_as @user
    get :box, type: 'send'
    assert_response :success
    @issues = assigns(:issues)
    assert_not_nil @issues
    @issues.each do |issue|
      assert @user.send_issues.include?(issue)
    end
    
    get :box, type: 'recieved'
    assert_response :success
    @issues = assigns(:issues)
    assert_not_nil @issues
    @issues.each do |issue|
      assert @user.recieved_issues.include?(issue)
    end
  end
  
  

end
