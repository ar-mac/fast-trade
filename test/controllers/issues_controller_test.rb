require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  def setup
    @issue = issues(:i_1)
    @reciever = @issue.reciever
    @sender = @issue.sender
    @other = users(:user_6)
    @admin = users(:admin)
  end
  
  test 'issue deactivation fail' do
    assert_no_difference 'Issue.count' do
      patch :update, id: @issue.id
      @issue.reload
      assert @issue.active_for_reciever
      assert @issue.active_for_sender
      assert_not_nil flash[:danger]
    end
    assert_no_difference 'Issue.count' do
      log_in_as @other
      patch :update, id: @issue.id
      @issue.reload
      assert @issue.active_for_reciever
      assert @issue.active_for_sender
      assert_not_nil flash[:danger]
    end
    assert_no_difference 'Issue.count' do
      log_in_as @admin
      patch :update, id: @issue.id
      @issue.reload
      assert @issue.active_for_reciever
      assert @issue.active_for_sender
      assert_not_nil flash[:danger]
    end
  end
  
  test 'issue reciever deactivation' do
    assert_no_difference 'Issue.count' do
      log_in_as @reciever
      patch :update, id: @issue.id
      @issue.reload
      assert_not @issue.active_for_reciever
      assert @issue.active_for_sender
      assert_not_nil flash[:success]
    end
  end
    
  test 'issue sender deactivation' do
    assert_no_difference 'Issue.count' do
      log_in_as @sender
      patch :update, id: @issue.id
      @issue.reload
      assert @issue.active_for_reciever
      assert_not @issue.active_for_sender
      assert_not_nil flash[:success]
    end
  end
  
  test 'issue destroy' do
    assert_no_difference 'Issue.count' do
      log_in_as @reciever
      patch :update, id: @issue.id
      @issue.reload
      log_in_as @sender
      patch :update, id: @issue.id
      @issue.reload
      assert_not @issue.active_for_reciever
      assert_not @issue.active_for_sender
      assert_not_nil flash[:success]
    end
  end
end
