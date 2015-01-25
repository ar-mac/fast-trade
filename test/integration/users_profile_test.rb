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
  
  test 'edit button visibility' do
    # log_in(@admin)
    # get user_path(@user)
    # assert_select "a[href=?], edit_user_path(@user)"
    # log_out(@admin)
    # log_in(@user2)
    # get user_path(@user)
    # assert_select "a[href=?], edit_user_path(@user), count: 0"
  end
  
end
