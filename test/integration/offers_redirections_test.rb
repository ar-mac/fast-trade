require 'test_helper'

class OffersRedirectionsTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users :admin
    @user1 = users :tom
    @o_active = @user1.offers.first
    @o_closed = @user1.offers.second
    @o_pending = @user1.offers.find(3)
    #he has no offers, so when used it's certain that he wont be mistakelny owner of the offer
    @user2 = users :user_5
    @inactive = users :inactive
    @inactive_user_closed_offer = offers :offer_50
  end
  
  test 'redirections for owner admin restricted actions' do
    log_in_as @user2
    assert_redirected_to user_path(@user2)
    follow_redirect!
    get edit_offer_path(@o_active)
    assert_redirected_to user_path(@user2)
  end
  
  test 'redirections for only owner' do
    log_in_as @admin
    assert_redirected_to user_path(@admin)
    follow_redirect!
    patch renew_offer_path(@o_closed)
    assert_redirected_to user_path(@admin)
  end
  
  test 'redirections for only active account' do
    log_in_as @inactive
    assert_redirected_to user_path(@inactive)
    follow_redirect!
    get new_offer_path
    assert_redirected_to user_path(@inactive)
  end
  
  test 'admin auth redirections' do
    log_in_as @user1
    assert_redirected_to user_path(@user1)
    follow_redirect!
    patch accept_offer_path(@o_pending)
    assert_redirected_to user_path(@user1)
  end
  
end
