require 'test_helper'

class OfferStatusesControllerTest < ActionController::TestCase
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
  
    test 'other user close/accept/renew offer' do
    log_in_as @user2
    delete :destroy, id: @o_active
    assert_redirected_to root_path
    @o_active.reload
    assert_equal 1, @o_active.status_id
    
    patch :update, id: @o_closed
    assert_redirected_to root_path
    @o_closed.reload
    assert_equal 2,  @o_closed.status_id
    
    post :create, id: @o_pending
    assert_redirected_to root_path
    @o_pending.reload
    assert_equal 0,  @o_pending.status_id
  end
  
  test 'owner close/accept/renew offer' do
    log_in_as @user1
    delete :destroy, id: @o_active
    assert_redirected_to @o_active
    @o_active.reload
    assert_equal 2, @o_active.status_id
    
    patch :update, id: @o_closed
    assert_redirected_to @o_closed
    @o_closed.reload
    assert_equal 0,  @o_closed.status_id
    
    post :create, id: @o_pending
    assert_redirected_to root_path
    @o_pending.reload
    assert_equal 0,  @o_pending.status_id
  end
  
  test 'admin close/accept/renew offer' do
    log_in_as @admin
    delete :destroy, id: @o_active
    assert_redirected_to @o_active
    @o_active.reload
    assert_equal 2, @o_active.status_id
    
    patch :update, id: @o_closed
    assert_redirected_to root_path
    @o_closed.reload
    assert_equal 2,  @o_closed.status_id
    
    post :create, id: @o_pending
    assert_redirected_to @o_pending
    @o_pending.reload
    assert_equal 1,  @o_pending.status_id
  end
  
    test 'inactive account restrictions' do
    log_in_as @inactive
    patch :update, id: @inactive_user_closed_offer
    assert_response :redirect
    assert_not_nil flash[:danger]
    
    delete :destroy, id: @inactive_user_closed_offer.id
    assert_response :redirect
    assert_not_nil flash[:danger]
  end
  
end
