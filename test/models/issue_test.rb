require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:tom)
    @offer = @user.offers.first
    @user2 = users(:bob)
    @issue = Issue.new(
      title: 'This title has proper length',
      sender_id: @user2.id,
      reciever_id: @user.id,
      offer_id: @offer.id
    )
  end
  
  test 'valid creation' do
    assert @issue.valid?
  end
  
  test 'invalid title' do
    @issue.update(title: ' ')
    assert_not @issue.valid?
    @issue.update(title: 'sho')
    assert_not @issue.valid?
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
  
end
