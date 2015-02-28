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
  
  test 'title validations' do
    statements = [
      ['Brand new snowmobile', true],
      ['Other title', true],
      [('a' * 25), true],
      [''],
      [(' ' * 20)],
      [('a' * 4)],
      [('a' * 41)]
    ]
    
    statements.each do |statement|
      @o_new.update( title: statement[0] )
      if statement[1]
        assert @o_new.valid?, model_error_explain(@o_new)
      else
        assert_not @o_new.valid?, failing_value(statement[0])
      end
    end
  end
  
  test 'content should be present' do
    statements = [
      [('text' * 10), true],
      [''],
      [(' ' * 40)],
      [('a' * 19)]
    ]
    
    statements.each do |statement|
      @o_new.update( content: statement[0] )
      if statement[1]
        assert @o_new.valid?, model_error_explain(@o_new)
      else
        assert_not @o_new.valid?, failing_value(statement[0])
      end
    end
  end
  
  test 'valid_until should be in the future' do
    @o_new.update( valid_until: Time.zone.today - 1.day )
    assert_not @o_new.valid?
    
    @o_new.update( valid_until: Time.zone.today )
    assert @o_new.valid?, model_error_explain(@o_new)
  end
  
  test 'status_id should be number in range' do
    statements = [
      [''],
      ['f'],
      [5],
      ['2', true],
      [1, true]
    ]
    statements.each do |statement|
      @o_new.update( status_id: statement[0] )
      if statement[1]
        assert @o_new.valid?, model_error_explain(@o_new)
      else
        assert_not @o_new.valid?, failing_value(statement[0])
      end
    end
  end
  
  test 'category_id should be number in range' do
    statements = [
      [''],
      ['f'],
      [Category::NAME_CODES.count],
      ['12'],
      [(Category::NAME_CODES.count - 1), true],
    ]
    statements.each do |statement|
      @o_new.update( category_id: statement[0] )
      if statement[1]
        assert @o_new.valid?, model_error_explain(@o_new)
      else
        assert_not @o_new.valid?, failing_value(statement[0])
      end
    end
  end
  
  test 'user_id should be present' do
    statements = [
      [''],
      [nil],
      [2, true],
    ]
    statements.each do |statement|
      @o_new.update( user_id: statement[0] )
      if statement[1]
        assert @o_new.valid?, model_error_explain(@o_new)
      else
        assert_not @o_new.valid?, failing_value(statement[0])
      end
    end
  end
  
  test 'mass expiration update' do
    expired_and_active = Offer.where('status_id = ? AND valid_until < ?', 1, Time.zone.now).count
    assert 0 < expired_and_active, "expired and active #{expired_and_active}"
    Offer.update_expiration
    expired_and_active = Offer.where('status_id = ? AND valid_until < ?', 1, Time.zone.now).count
    assert_equal 0, expired_and_active, "still expired and active #{expired_and_active}"
  end
  
end
