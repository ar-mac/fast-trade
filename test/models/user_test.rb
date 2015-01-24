require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:tom)
    @admin = users(:admin)
    @user2 = User.new(name: 'Mark999',
                      password: 'asdfasdf',
                      password_confirmation: 'asdfasdf',
                      region: 'Łódzkie')
  end
  
  test 'name validations' do
    
    @user2.update(name: '')
    assert_not @user2.valid?, 'user name is blank'
    
    @user2.update(name: @user.name)
    assert_not @user2.valid?, 'user name is not unique'
    
    @user2.update(name: 'aa')
    assert_not @user2.valid?, 'user name is less than 3 letters'
    
    @user2.update(name: 'a' * 21 )
    assert_not @user2.valid?, 'user name is more than 20 letters'
    
    @user2.update(name: 'Mark999')
    assert @user2.valid?, 'user name is correct'
    assert @user2.active?, 'user is inactive'
    assert_not @user2.admin?, 'user is admin'
  end
  
  test 'region validations' do
    
    User::REGIONS.each do |reg|
      @user2.update(region: reg)
      assert @user2.valid?, "#{reg} is invalid"
    end
    
    incorrect_regions = ['slask', 'mazowsze', 'washington', 'łódź', 'łódzkie']
    incorrect_regions.each do |reg|
      @user2.update(region: reg)
      assert_not @user2.valid?, "#{reg} is valid"
    end
    
  end
  
  test 'password validations' do
    
    @user2.update( password: 'asdfasdf',
                  password_confirmation: 'qwerqwer')
    assert_not @user2.valid?, 'wrong password confirmation'
    
    @user2.update(password: '', password_confirmation: '')
    assert_not @user2.valid?, 'passwords empty'
    
    @user2.update(password: 'asdfas', password_confirmation: 'asdfas')
    assert_not @user2.valid?, 'password too short'
  end
  
end
