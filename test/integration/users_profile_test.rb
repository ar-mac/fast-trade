require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:tom)
    @other = users(:bob)
    @admin = users(:admin)
  end
  
  test 'showing proper_user profile' do
    get user_path(id: @user)
    assert_redirected_to login_path
    
    log_in_as(@user)
    get user_path(@user)
    assert_select "li.list-group-item", /#{@user.name}/, count: 1
    assert_select "li.list-group-item", /#{@user.region}/, count: 1
  end
  
  test 'profile buttons visibility for admin' do
    log_in_as(@admin)
    get user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user), count: 1
  end
  
  test 'profile buttons visibility for owner' do
    log_in_as(@user)
    get user_path(@user)
    assert_select "a.btn[href=?]", edit_user_path(@user), count: 1
  end
    
  test 'profile buttons visibility for guest' do
    log_in_as(@other)
    get user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user), count: 0
  end
  
end
