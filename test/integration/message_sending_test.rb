require 'test_helper'

class MessageSendingTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users :admin
    @user1 = users :tom
    @o_active = @user1.offers.first
    #he has no offers, so when used it's certain that he wont be mistakelny owner of the offer
    @user6 = users :user_6
    @inactive = users :inactive
  end
  
  test 'user' do
    assert @user6.active
  end
  
  test 'non logged user' do
    get offer_path(id: @o_active)
    assert_response :success
    assert_select "a[href = ?]", issues_path, text: I18n.t('links.message.login_to_send')
    assert_nil assigns :params_for_issue
    post issues_path
    assert_redirected_to login_path
  end
  
  test 'logged non owner user' do
    log_in_as @user6
    get offer_path(id: @o_active)
    assert_response :success
    @par = assigns :params_for_issue
    assert_select "a[href]", text: I18n.t('links.message.send')
    post_via_redirect issues_path(@par)
    assert_response :success
    assert_template 'issues/show'
    post messages_path, 
      message: {
        content: "Thats content of the msg",
        issue_id: assigns(:issue).id,
        author_id: assigns(:current_user).id,
      },
      offer_id: assigns(:offer).id
    assert_redirected_to issue_path(id: assigns(:issue))
  end
  
  test 'logged owner user' do
    log_in_as @user1
    get offer_path(id: @o_active)
    assert_response :success
    assert_nil assigns :params_for_issue
    assert_select "a[href]", text: I18n.t('links.message.send'), count: 0
  end
  
    test 'logged inactive user' do
    log_in_as @inactive
    get offer_path(id: @o_active)
    assert_response :success
    assert_nil assigns :params_for_issue
    assert_select "a[href]", text: I18n.t('links.message.send'), count: 1
    post issues_path()
    assert_response :redirect
    assert_redirected_to offer_path(id: @o_active)
    assert_template 'offers/show'
    assert_not_nil flash[:danger]
  end
  
  test 'many user responses' do
    interested_users = [users(:user_8), @user6, users(:user_10)]
    
    interested_users.each do |user|
      log_in_as user
      get offer_path(id: @o_active)
      @par = assigns :params_for_issue
      post issues_path(@par)
      follow_redirect!
      post_via_redirect messages_path, 
        message: {
          content: "Thats content of the msg #{user.name}",
          issue_id: assigns(:issue).id,
          author_id: assigns(:current_user).id,
        },
        offer_id: assigns(:offer).id
    end
    
    interested_users.each do |user|
      log_in_as user
      get messagebox_path(type: 'send')
      assert_select "div.list-group-item.issue" do
        assert_select "a[href = ?]", offer_path(id: @o_active)
        assert_select "a[href = ?]", user_path(id: @o_active.owner)
      end
    end
    
    log_in_as @user1
    get messagebox_path(type: 'recieved')
    assert_select "ul.navbar-right" do
      assert_select "a#text-info", text: /\(3\)/
    end
    interested_users.each do |user|
      assert_select "div.list-group-item.issue" do
        assert_select "a[href = ?]", offer_path(id: @o_active)
        assert_select "a[href = ?]", user_path(id: user)
      end
    end
    
  end
  
  
end
