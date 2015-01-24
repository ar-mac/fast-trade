require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:tom)
    @admin = users(:admin)
  end
  
  test 'name validations' do
    
    user = User.new(  password: 'asdfasdf',
                      password_confirmation: 'asdfasdf',
                      region: 'Łódzkie')
    assert_not user.valid?, 'user name is blank'
    
    user.update(name: @user.name)
    assert_not user.valid?, 'user name is not unique'
    
    user.update(name: 'aa')
    assert_not user.valid?, 'user name is less than 3 letters'
    
    user.update(name: 'a' * 21 )
    assert_not user.valid?, 'user name is more than 20 letters'
    
    user.update(name: 'Mark999')
    assert user.valid?, 'user name is correct'
    assert user.active?, 'user is inactive'
    assert_not user.admin?, 'user is admin'
  end
  
  test 'region validations' do
    
    user = User.new( name: 'Mark999',
                      password: 'asdfasdf',
                      password_confirmation: 'asdfasdf')
    User::REGIONS.each do |reg|
      user.update(region: reg)
      assert user.valid?, "#{reg} is invalid"
    end
    
    incorrect_regions = ['slask', 'mazowsze', 'washington', 'łódź', 'łódzkie']
    incorrect_regions.each do |reg|
      user.update(region: reg)
      assert_not user.valid?, "#{reg} is valid"
    end
  end
  
  test 'password validations' do
    
    user = User.new( name: 'Mark999',
                      password: 'asdfasdf',
                      password_confirmation: 'qwerqwer',
                      region: 'Łódzkie')
    assert_not user.valid?, 'wrong password confirmation'
    
    user.update(password: '', password_confirmation: '')
    assert_not user.valid?, 'passwords empty'
    
    user.update(password: 'asdfas', password_confirmation: 'asdfas')
    assert_not user.valid?, 'password too short'
  end
  
end
