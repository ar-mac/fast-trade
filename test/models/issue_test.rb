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
    assert @issue.valid?, "fail because #{@issue.errors.messages}"
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
    assert_not @issue_x.valid?, "fail because #{@issue_x.errors.messages}"
    assert_not_nil @issue_x.errors.messages
  end
  
end
