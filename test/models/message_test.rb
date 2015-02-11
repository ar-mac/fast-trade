require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @issue1 = issues(:one)
    @message1 = Message.create(
      content: 'This content has enough length to be valid',
      issue_id: @issue1.id
    )
  end
  
  test 'valid message' do
    assert @message1.valid?
    assert_nil @message1.read_at
  end
  
  test 'content validations' do
    @message1.update(content: nil )
    assert_not @message1.valid?
    @message1.update(content: 'too short' )
    assert_not @message1.valid?
    @message1.update(content: 'a' * 20 )
    assert @message1.valid?
  end
  
  test 'issue_id validations' do
    @message1.update(issue_id: nil)
    assert_not @message1.valid?
    @message1.update(issue_id: '')
    assert_not @message1.valid?
    @message1.update(issue_id: @issue1.id )
    assert @message1.valid?, "failed because #{@message1.errors.full_messages}"
  end
  
  
end
