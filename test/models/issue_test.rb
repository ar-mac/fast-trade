require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:tom)
    @offer = @user.offers.first
    @user2 = users(:user_6)
    @issue = Issue.new(
      sender_id: @user2.id,
      reciever_id: @user.id,
      offer_id: @offer.id
    )
  end
  
  test 'a valid creation' do
    assert @issue.valid?, model_error_explain(@issue)
  end
  
  test 'invalid sender' do
    @issue.update(sender_id: nil)
    assert_not @issue.valid?
    @issue.update(sender_id: '')
    assert_not @issue.valid?
  end
  
  test 'invalid reciever' do
    @issue.update(reciever_id: nil)
    assert_not @issue.valid?
    @issue.update(reciever_id: '')
    assert_not @issue.valid?
  end
  
  test 'duplicate issue' do
    @issue_x = Issue.create(
      sender_id: @user2.id,
      reciever_id: @user.id,
      offer_id: @offer.id
    )
    assert_not @issue_x.valid?, model_error_explain(@issue_x)
  end
  
  test 'checking deactivation' do
    assert_not @issue.both_deactivate?
    
    @issue.sender_deactivate
    @issue.reload
    assert_not @issue.active_for?(@user2)
    assert_not @issue.both_deactivate?
    
    @issue.reciever_deactivate
    @issue.reload
    assert_not @issue.active_for?(@user)
    assert @issue.both_deactivate?
    
    @issue.activate_all
    @issue.reload
    assert @issue.active_for?(@user)
    assert @issue.active_for?(@user2)
    
  end
  
end
