require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:tom)
    @admin = users(:admin)
    @other = users(:bob)
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
    @user.reload
    assert_not @user.active?
    
    delete :destroy, id: @user.id
    assert flash[:danger]
    @user.reload
    assert_not @user.active?
  end
    
  test 'admin able to destroy user account' do
    log_in_as(@admin)
    delete :destroy, id: @user.id
    assert flash[:info]
    @user.reload
    assert_not @user.active?
    
    delete :destroy, id: @user.id
    assert flash[:danger]
    @user.reload
    assert_not @user.active?
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
  
  test 'admin cant even try to edit password' do
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
  end

end
