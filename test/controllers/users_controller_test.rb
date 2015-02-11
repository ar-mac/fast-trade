require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:tom)
    @admin = users(:admin)
    @other = users(:bob)
    @inactive = users(:inactive)
  end
  
  test "show action validations" do
    get :show, id: @user.id
    assert_response :redirect
    
    log_in_as(@user)
    get :show, id: @user.id
    assert_response :success
    
    log_in_as(@other)
    get :show, id: @user.id
    assert_response :success
    
    log_in_as(@admin)
    get :show, id: @user.id
    assert_response :success
  end
  
  test 'redirect for inexisting user' do
    log_in_as(@user)
    get :show, id: 0
    assert_response :redirect
    get :edit, id: 0
    assert_response :redirect
    post :update, id: 0
    assert_response :redirect
    delete :destroy, id: 0
    assert_response :redirect
  end

  test "index authorization" do
    get :index
    assert_response :redirect
    
    log_in_as(@user)
    get :index
    assert_response :redirect
    
    log_in_as(@admin)
    get :index
    assert_response :success
  end

  test "new action authorization" do
    get :new
    assert_response :success
    
    log_in_as(@user)
    get :new
    assert_response :redirect
  end

  test "edit authorization" do
    get :edit, id: @user.id
    assert_response :redirect
    
    log_in_as(@inactive)
    get :edit, id: @inactive.id
    assert_response :redirect
    
    log_in_as(@other)
    get :edit, id: @user.id
    assert_response :redirect
    
    log_in_as(@user)
    get :edit, id: @user.id
    assert_response :success
    
    log_in_as(@admin)
    get :edit, id: @user.id
    assert_response :success
  end
  
  test "destroy not authorized" do
    delete :destroy, id: @user.id
    assert flash[:danger]
    
    log_in_as(@other)
    delete :destroy, id: @user.id
    assert flash[:danger]
  end
  
  test 'user able to destroy his account' do
    log_in_as(@user)
    delete :destroy, id: @user.id
    assert flash[:info]
    assert_not User.find_by(id: @user.id)
  end
    
  test 'admin able to destroy user account' do
    log_in_as(@admin)
    delete :destroy, id: @user.id
    assert flash[:info]
    assert_not User.find_by(id: @user.id)
  end
  
  test 'editing profile without password change' do
    log_in_as(@user)
    patch :update, id: @user.id, user: {
      name: 'Newname',
      region: User::REGIONS[2],
      password: '',
      password_confirmation: '',
      old_password: ''
    }
    assert_response :redirect
    assert_redirected_to user_path(@user)
    assert flash[:success]
  end
  
  test 'editing profile with correct password change' do
    log_in_as(@user)
    patch :update, {
      id: @user.id, 
      user: {
        name: 'Newname',
        region: User::REGIONS[2],
        password: 'newpassword',
        password_confirmation: 'newpassword'
      },
      old_password: 'asdfasdf'
    }
    
    assert_response :redirect
    assert_redirected_to user_path(@user)
    assert flash[:info]
    assert flash[:success]
    @user.reload
    assert @user.authenticate('newpassword')
  end
  
  test 'editing profile with incorrect password change' do
    log_in_as(@user)
    patch :update, {
      id: @user.id, 
      user: {
        name: 'Newname',
        region: User::REGIONS[2],
        password: 'newpassword',
        password_confirmation: 'newpassword'
      },
      old_password: 'wrongpassword'
    }
    
    assert_response :redirect
    assert_redirected_to user_path(@user)
    assert_not flash[:info]
    assert flash[:success]
    @user.reload
    assert @user.authenticate('asdfasdf')
  end
  
  test 'editing profile with blank old_password' do
    log_in_as(@user)
    patch :update, {
      id: @user.id, 
      user: {
        name: 'Newname',
        region: User::REGIONS[2],
        password: 'newpassword',
        password_confirmation: 'newpassword'
      },
      old_password: ''
    }
    
    assert_response :redirect
    assert_redirected_to user_path(@user)
    assert_not flash[:info]
    assert flash[:success]
    @user.reload
    assert @user.authenticate('asdfasdf')
  end
  
  test "admin cant edit user's password" do
    log_in_as(@admin)
    patch :update, {
      id: @user.id, 
      user: {
        name: 'Newname',
        region: User::REGIONS[2],
        password: 'newpassword',
        password_confirmation: 'newpassword'
      },
      old_password: 'asdfasdf'
    }
    
    assert_response :redirect
    assert_redirected_to user_path(@user)
    assert_not flash[:info]
    assert flash[:success]
    @user.reload
    assert @user.authenticate('asdfasdf')
  end
  
  test 'users index' do
    log_in_as(@admin)
    get :index
    @users = assigns(:users)
    @users.each do |user|
      assert user.active?
    end
    
    get :index, {region: 'Śląskie'}
    @users = assigns(:users)
    @users.each do |user|
      assert user.region == 'Śląskie'
    end
    
    get :index, {active: '1'}
    @users = assigns(:users)
    @users.each do |user|
      assert user.active?
    end
    
    get :index, {inactive: '1'}
    @users = assigns(:users)
    @users.each do |user|
      assert_not user.active?
    end
    
    get :index, {
      inactive: '1',
      active: '1'
    }
    @users = assigns(:users)
    @active = @users.select {|user| user.active? }
    @inactive = @users.select {|user| !user.active? }
    assert @active.count > 0
    assert @inactive.count > 0
    assert_select 'b.text-success', count: @active.count
    assert_select 'b.text-danger', count: @inactive.count
  end
  
  test 'activate permissions' do
    patch :activate, id: @user.id
    assert_redirected_to login_path
    assert flash[:danger]
    
    log_in_as(@other)
    patch :activate, id: @user.id
    assert_redirected_to root_path
    assert flash[:danger]
    
    log_in_as(@user)
    patch :activate, id: @user.id
    assert_redirected_to root_path
    assert flash[:danger]
    
    log_in_as(@admin)
    patch :activate, id: @user.id
    assert_redirected_to user_path(@user)
    assert flash[:info]
  end
  
  test 'deactivate permissions' do
    patch :deactivate, id: @user.id
    assert_redirected_to login_path
    assert flash[:danger]
    
    log_in_as(@other)
    patch :deactivate, id: @user.id
    assert_redirected_to root_path
    assert flash[:danger]
    
    log_in_as(@user)
    patch :deactivate, id: @user.id
    assert_redirected_to root_path
    assert flash[:danger]
    
    log_in_as(@admin)
    patch :deactivate, id: @user.id
    assert_redirected_to user_path(@user)
    assert flash[:info]
    @user.offers.each do |offer|
      assert offer.status_id == 2
    end
  end
  
  test 'user destroy permissions' do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user.id
      assert_redirected_to login_path
      assert flash[:danger]
    end
    assert_no_difference 'User.count' do
      log_in_as @other
      delete :destroy, id: @user.id
      assert_redirected_to root_path
      assert flash[:danger]
    end
    
    assert_difference 'User.count', -1 do
      log_in_as @user
      delete :destroy, id: @user.id
      assert_redirected_to root_path
      assert flash[:info]
    end
    
  end
  
  test 'admin destroy' do
    assert_difference 'User.count', -1 do
      log_in_as @admin
      delete :destroy, id: @user.id
      assert_redirected_to root_path
      assert flash[:info]
    end
  end

end
