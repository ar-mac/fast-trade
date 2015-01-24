require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:tom)
    @admin = users(:admin)
  end
  
  test "should get show" do
    get :show, id: @user.id
    assert_response :success
  end
  
  

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user.id
    assert_response :success
  end
  
  

end
