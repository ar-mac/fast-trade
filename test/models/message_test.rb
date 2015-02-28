require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @user = users(:tom)
    @user2 = users(:bob)
    @issue1 = issues(:i_1)
    @message1 = Message.create(
      content: 'This content has enough length to be valid',
      issue_id: @issue1.id,
      author_id: @user.id
    )
  end
  
  test 'valid message and clearing being new' do
    assert @message1.valid?, model_error_explain(@message1)
    assert_not_nil @message1.new_for_user_id
    assert_nil @message1.read_at
    
    @message1.clear_being_new_for(@user)
    @message1.reload
    assert_not_nil @message1.new_for_user_id
    assert_nil @message1.read_at
    
    @message1.clear_being_new_for(@user2)
    @message1.reload
    assert_nil @message1.new_for_user_id
    assert_not_nil @message1.read_at
  end
  
  test 'content validations' do
    [nil, 'sho'].each do |val|
      @message1.update(content: val)
      assert_not @message1.valid?, failing_value(val)
    end
    
    @message1.update(content: 'a' * 5 )
    assert @message1.valid?, model_error_explain(@message1)
  end
  
  test 'issue_id validations' do
    [nil, ''].each do |val|
      @message1.update(issue_id: val)
      assert_not @message1.valid?, failing_value(val)
    end
    
    @message1.update(issue_id: @issue1.id )
    assert @message1.valid?, model_error_explain(@message1)
  end
  
  test 'clearing new status' do
    
  end
  
end
