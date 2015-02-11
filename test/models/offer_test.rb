require 'test_helper'

class OfferTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:tom)
    @o_1 = offers(:offer_1)
    @o_new = Offer.new(
      title: 'Great perfect diamond',
      content: Faker::Lorem.sentence(10),
      valid_until: (Time.zone.today + 3.days),
      status_id: 1, #active
      category_id: 0, #main
      user_id: @user.id 
    )
  end
  
  test 'title should be present' do
    @o_new.update( title: '' )
    assert_not @o_new.valid?
    
    @o_new.update( title: ' ' * 20 )
    assert_not @o_new.valid?
    
    @o_new.update( title: 'Brand new snowmobile' )
    assert @o_new.valid?, "Invalid because: #{@o_new.errors.full_messages}"
  end
  
  test 'title should be unique' do
    @o_new.update( title: @o_1.title )
    assert_not @o_new.valid?
    
    @o_new.update( title: 'Other title' )
    assert @o_new.valid?, "Invalid because: #{@o_new.errors.full_messages}"
  end
  
  test 'title should have proper length' do
    @o_new.update( title: 'a' * 4 )
    assert_not @o_new.valid?
    
    @o_new.update( title: 'a' * 41 )
    assert_not @o_new.valid?
    
    @o_new.update( title: 'a' * 25 )
    assert @o_new.valid?, "Invalid because: #{@o_new.errors.full_messages}"
  end
  
  test 'content should be present' do
    @o_new.update( content: '' )
    assert_not @o_new.valid?
    
    @o_new.update( content: ' ' * 40 )
    assert_not @o_new.valid?
    
    @o_new.update( content: 'text' * 10 )
    assert @o_new.valid?, "Invalid because: #{@o_new.errors.full_messages}"
  end
  
  test 'content should have proper length' do
    @o_new.update( content: 'a' * 19 )
    assert_not @o_new.valid?
    
    @o_new.update( content: 'a' * 41 )
    assert @o_new.valid?, "Invalid because: #{@o_new.errors.full_messages}"
  end
  
  test 'valid_until should be in the future' do
    @o_new.update( valid_until: Time.zone.today - 1.day )
    assert_not @o_new.valid?
    
    @o_new.update( valid_until: Time.zone.today )
    assert @o_new.valid?, "Invalid because: #{@o_new.errors.full_messages}"
  end
  
  test 'status_id should be number in range' do
    @o_new.update( status_id: '' )
    assert_not @o_new.valid?
    
    @o_new.update( status_id: 'f' )
    assert_not @o_new.valid?
    
    @o_new.update( status_id: 5 )
    assert_not @o_new.valid?
    
    @o_new.update( status_id: '2' )
    assert @o_new.valid?, "Invalid because: #{@o_new.errors.full_messages}"
    
    @o_new.update( status_id: 1 )
    assert @o_new.valid?, "Invalid because: #{@o_new.errors.full_messages}"
  end
  
  test 'category_id should be number in range' do
    @o_new.update( category_id: '' )
    assert_not @o_new.valid?
    
    @o_new.update( category_id: 'f' )
    assert_not @o_new.valid?
    
    @o_new.update( category_id: Category::NAME_CODES.count )
    assert_not @o_new.valid?
    
    @o_new.update( category_id: '12' )
    assert_not @o_new.valid?
    
    @o_new.update( category_id: (Category::NAME_CODES.count - 1) )
    assert @o_new.valid?, "Invalid because: #{@o_new.errors.full_messages}"
  end
  
  test 'user_id should be present' do
    @o_new.update( user_id: '' )
    assert_not @o_new.valid?
    
    @o_new.update( user_id: 2 )
    assert @o_new.valid?, "Invalid because: #{@o_new.errors.full_messages}"
  end
  
end
