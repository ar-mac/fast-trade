require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tom)
    @admin = users(:admin)
  end
  
  test 'showing proper_user profile' do
    get user_path(@user)
    assert_select "title", "FastTrade"
    assert_select "li.list-group-item", /#{@user.name}/, count: 1
    assert_select "li.list-group-item", /#{@user.region}/, count: 1
  end
  
  test 'profile buttons visibility' do
    # log_in_as(@admin)
    # get user_path(@user)
    # assert_select "a[href=?], edit_user_path(@user), count: 1"
    # assert_select "a[href=?], edit_admin_user_path(@user), count: 1"
    # log_out(@admin)
    
    # log_in_as(@user)
    # get user_path(@user)
    # assert_select "a[href=?], edit_user_path(@user), count: 1"
    # assert_select "a[href=?], edit_admin_user_path(@user), count: 0"
    # log_out(@user)
    
    # log_in_as(@user2)
    # get user_path(@user)
    # assert_select "a[href=?], edit_user_path(@user), count: 0"
    # assert_select "a[href=?], edit_admin_user_path(@user), count: 0"
  end
  
end
