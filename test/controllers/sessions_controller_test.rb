require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  def setup
    @user = users :tom
  end
  
  test "getting new" do
    get :new
    assert_response :success
    
    log_in_as @user
    get :new
    assert_response :success
  end
  
  test "valid login credentials" do
    post :create, session: {
      name: @user.name,
      password: 'asdfasdf',
      remember_me: '0'
    }
    assert_response :redirect
    assert flash[:success]
    assert is_logged_in?
    assert session[:user_id] == @user.id
  end
  
  test "invalid login credentials" do
    post :create, session: {
      name: 'wrongname',
      password: 'asdfasdf',
      remember_me: '0'
    }
    assert_response :success
    assert flash[:danger]
    assert_not is_logged_in?
    
    post :create, session: {
      name: @user.name,
      password: 'wrongpassword',
      remember_me: '0'
    }
    assert_response :success
    assert flash[:danger]
    assert_not is_logged_in?
  end
  
  test 'logging out' do
    delete :destroy, id: @user.id
    assert_response :redirect
    assert_not is_logged_in?
    assert flash[:danger]
    
    log_in_as @user
    delete :destroy, id: @user.id
    assert_response :redirect
    assert_not is_logged_in?
    assert flash[:success]
  end

end
