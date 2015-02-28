require 'test_helper'

class ActivationsControllerTest < ActionController::TestCase
  
  def setup
    @user = users :tom
    @admin = users :admin
    @other = users :bob
    @inactive = users :inactive
  end
  
  test 'activate permissions' do
    patch :create, id: @user.id
    assert_redirected_to login_path
    assert flash[:danger]
    
    log_in_as @other
    patch :create, id: @user.id
    assert_redirected_to root_path
    assert flash[:danger]
    
    log_in_as @user
    patch :create, id: @user.id
    assert_redirected_to root_path
    assert flash[:danger]
    
    log_in_as @admin
    patch :create, id: @user.id
    assert_redirected_to user_path @user
    assert flash[:info]
  end
  
  test 'deactivate permissions' do
    patch :destroy, id: @user.id
    assert_redirected_to login_path
    assert flash[:danger]
    
    log_in_as @other
    patch :destroy, id: @user.id
    assert_redirected_to root_path
    assert flash[:danger]
    
    log_in_as @user
    patch :destroy, id: @user.id
    assert_redirected_to root_path
    assert flash[:danger]
    
    log_in_as @admin
    patch :destroy, id: @user.id
    assert_redirected_to user_path @user
    assert flash[:info]
    @user.offers.each do |offer|
      assert offer.status_id == 2
    end
  end
end
