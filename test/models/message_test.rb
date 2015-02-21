require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @user = users(:tom)
    @issue1 = issues(:i_1)
    @message1 = Message.create(
      content: 'This content has enough length to be valid',
      issue_id: @issue1.id,
      author_id: @user.id
    )
  end
  
  test 'valid message' do
    assert @message1.valid?, "invalid because: #{@message1.errors.full_messages}"
    assert_nil @message1.read_at
  end
  
  test 'content validations' do
    @message1.update(content: nil )
    assert_not @message1.valid?
    @message1.update(content: 'sho' )
    assert_not @message1.valid?
    @message1.update(content: 'a' * 5 )
    assert @message1.valid?, "invalid because: #{@message1.errors.full_messages}"
  end
  
  test 'issue_id validations' do
    @message1.update(issue_id: nil)
    assert_not @message1.valid?
    @message1.update(issue_id: '')
    assert_not @message1.valid?
    @message1.update(issue_id: @issue1.id )
    assert @message1.valid?, "invalid because #{@message1.errors.full_messages}"
  end
  
  
end
