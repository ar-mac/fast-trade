require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:tom)
    @admin = users(:admin)
    
  end
  
  test "should get show" do
    get :show, id: @user.id
    assert_response :redirect
    
    log_in_as(@user)
    get :show, id: @user.id
    assert_response :success
  end
  
  test 'should not get show pages of inexisting user' do
    get :show, id: 0
    assert_redirected_to root_path
    get :edit, id: 0
    assert_redirected_to root_path
    post :update, id: 0
    assert_redirected_to root_path
    delete :destroy, id: 0
    assert_redirected_to root_path
  end

  test "should get index" do
    get :index
    assert_response :redirect
    
    log_in_as(@user)
    get :index
    assert_response :redirect
    
    log_in_as(@admin)
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user.id
    assert_response :redirect
    
    log_in_as(@user)
    get :edit, id: @user.id
    assert_response :success
  end
  
  

end
