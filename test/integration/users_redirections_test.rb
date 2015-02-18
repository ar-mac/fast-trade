require 'test_helper'

class UsersRedirectionsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users :tom
    @admin = users :admin
    @other = users :bob
    @inactive = users :inactive
  end
  
  test 'login with valid redirection' do
    #showing offers
    get "/pl/#{offers_path}"
    assert_response :success
    #showing offer
    offers = assigns :offers
    get offer_path(offers.first)
    assert_response :success
    #attempt to show user
    user = assigns :user
    get user_path(user)
    assert_response :redirect
    assert_redirected_to login_path
    
    #mimics behaviour of browser which gets login_path and then user can post login_path
    get login_path 
    post login_path, session: { name:       @user.name,
                                password:    'asdfasdf',
                                remember_me: 0 }
    assert_redirected_to user_path(user)
  end
  
  test 'login with invalid redirection' do
    #showing offers
    get "/pl/#{offers_path}"
    assert_response :success
    #showing offer
    offers = assigns :offers
    get offer_path(offers.first)
    assert_response :success
    #attempt to show user index
    get users_path
    assert_response :redirect
    assert_redirected_to login_path
    
    #mimics behaviour of browser which gets login_path and then user can post login_path
    get login_path
    post login_path, session: { name: @user.name,
                                      password:    'asdfasdf',
                                      remember_me: 0 }
    assert_redirected_to users_path
    follow_redirect!
    assert_redirected_to "#{root_path}?locale=pl"
    follow_redirect!
    assert_response :success
  end
  
  test 'automatic logout' do
    log_in_as @user
    get login_path
    assert_equal '/pl/login', path
    assert_response :success
    
    log_in_as @user
    get new_user_path
    assert_equal '/pl/register', path
    assert_response :success
  end
  
  test 'admin auth redirection' do
    log_in_as @user
    follow_redirect!
    assert_equal "/pl/users/#{@user.id}", path
    get users_path
    assert_redirected_to "/pl/users/#{@user.id}"
    assert_not_nil flash[:danger]
    
    log_in_as @admin
    follow_redirect!
    assert_equal "/pl/users/#{@admin.id}", path
    get users_path
    assert_response :success
  end
  
  test 'owner and admin restricted actions' do
    log_in_as @other
    follow_redirect!
    assert_equal "/pl/users/#{@other.id}", path
    get edit_user_path(@user)
    assert_redirected_to "/pl/users/#{@other.id}"
    assert_not_nil flash[:danger]
    
    log_in_as @user
    follow_redirect!
    assert_equal "/pl/users/#{@user.id}", path
    get edit_user_path(@user)
    assert_response :success
  end
  
  test 'inactive account redirections' do
    log_in_as @other
    follow_redirect!
    assert_equal "/pl/users/#{@other.id}", path
    get user_path(@inactive)
    assert_redirected_to "/pl/users/#{@other.id}"
    assert_not_nil flash[:danger]
    
    log_in_as @admin
    follow_redirect!
    assert_equal "/pl/users/#{@admin.id}", path
    get user_path(@inactive)
    assert_response :success
  end
  
  
  
end
