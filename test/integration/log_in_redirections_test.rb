require 'test_helper'

class LogInRedirectionsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tom)
    @admin = users(:admin)
  end
  
  test 'clean login without redirections' do
    #showing offers
    get "/pl/#{offers_path}"
    assert_equal '/pl/offers', path
    assert_template 'offers/index'
    assert_response :success
    #showing offer
    offers = assigns(:offers)
    get offer_path(offers.first)
    assert_response :success
    #attempt to show user
    user = assigns(:user)
    get user_path(user)
    assert_response :redirect
    assert_redirected_to login_path
    post login_path, session: { name:       @user.name,
                                password:    'asdfasdf',
                                remember_me: 0 }
    debugger
    assert_redirected_to user_path(user)
  end
  
  
  
end
