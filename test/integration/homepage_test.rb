require 'test_helper'

class HomepageTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tom)
    @admin = users(:admin)
  end
  
  test 'links for non logged in person' do
    get root_path
    assert_template 'statics/home'
    # assert_select "a[href = ?], login_path, count: 2"
    # assert_select "a[href = ?], register_path, count: 2"
    # assert_select "a[href = ?], offers_path, count: 2"
  end
  
  test 'links for logged in user' do
    # log_in(@user)
    # get root_path
    # assert_select "a[href = ?], login_path, count: 1"
    # assert_select "a[href = ?], register_path, count: 1"
    
    # assert_select "a[href = ?], user_path(@user), count: 1"
    # assert_select "a[href = ?], edit_user_path(@user), count: 1"
    # assert_select "a[href = ?], user_offers_path(@user), count: 1"
    # assert_select "a[href = ?], new_offer_path(@user), count: 1"
    
    # assert_select "a[href = ?], logout_path, count: 1"
    
  end
  
  test 'link for admin user' do
    # log_in(@user)
    # get root_path
    # assert_select "a[href = ?], login_path, count: 1"
    # assert_select "a[href = ?], register_path, count: 1"
    
    # assert_select "a[href = ?], user_path(@user), count: 1"
    # assert_select "a[href = ?], edit_user_path(@user), count: 1"
    # assert_select "a[href = ?], user_offers_path(@user), count: 1"
    # assert_select "a[href = ?], new_offer_path(@user), count: 1"
    # assert_select "a[href = ?], logout_path, count: 1"
    
    # assert_select "a[href = ?], admin_users_path, count: 1"
    # assert_select "a[href = ?], admin_offers_path, count: 1"
    # assert_select "a[href = ?], admin_offers_path(status: 0), count: 1"
  end
  
  test 'existence of search form' do
    get root_path
    assert_select '.form-search', count: 1
    assert_select 'input[type=submit]', count: 1
  end
  
end
