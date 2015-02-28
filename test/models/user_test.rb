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
    incorrect_statements = [
      ['', 'user name is blank'],
      [@user.name, 'user name is not unique'],
      ['aa',  'user name is less than 3 letters'],
      [('a' * 36), 'user name is more than 20 letters']
    ]
    
    incorrect_statements.each do |statement|
      @user2.update(name: statement[0])
      assert_not @user2.valid?, statement[1]
    end
    
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
    incorrect_passw = [
      ['asdfasdf','qwerqwer','wrong password confirmation'],
      ['','','passwords empty'],
      ['asdfas','asdfas','passwords too short']
    ]
    incorrect_passw.each do |incorrect|
      @user2.update(password: incorrect[0], password_confirmation: incorrect[1])
      assert_not @user2.valid?, incorrect[2]
    end
    
    @user2.update(password: 'proper-passw', password_confirmation: 'proper-passw')
      assert @user2.valid?, 'password is invalid'
    
  end
  
  test 'user activation/deactivation' do
    assert @user.active?
    assert_not_nil @user.offers.where(status_id: 1)
    @user.deactivate
    @user.reload
    assert @user.inactive?
    assert_equal @user.offers.count, @user.offers.where(status_id: 2).count, 
      'Not all user offers were closed'
    
    @user.activate
    @user.reload
    assert @user.active?
    assert_equal @user.offers.count, @user.offers.where(status_id: 2).count, 
      "When user was activated offers didn't stayed closed"
  end
  
end
