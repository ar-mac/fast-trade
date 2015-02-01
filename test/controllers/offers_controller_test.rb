require 'test_helper'

class OffersControllerTest < ActionController::TestCase
  
  def setup
    @admin = users(:admin)
    @user1 = users(:tom)
    @o_active = @user1.offers.first
    @o_closed = @user1.offers.second
    @o_pending = @user1.offers.find(3)
    #he has no offers, so when used it's certain that he wont be mistakelny owner of the offer
    @user2 = users(:user_5)
  end
  
  test "show for non logged user" do
    get :show, id: @o_active.id
    assert_response :success
    assert_select 'a[href = ?]', edit_offer_path(@o_active), count: 0
    assert_select 'a[href = ?]', close_offer_path(@o_active), count: 0
    assert_select 'a[href = ?]', offer_path(@o_active), text: I18n.t('links.destroy'), count: 0
    
    assert_select 'a[href = ?]', renew_offer_path(@o_active), count: 0
    assert_select 'a[href = ?]', accept_offer_path(@o_active), count: 0
  end
  
  test "show for logged other user" do
    log_in_as(@user2)
    get :show, id: @o_active.id
    assert_response :success
    assert_select 'a[href = ?]', edit_offer_path(@o_active), count: 0
    assert_select 'a[href = ?]', close_offer_path(@o_active), count: 0
    assert_select 'a[href = ?]', offer_path(@o_active), text: I18n.t('links.destroy'), count: 0
    
    assert_select 'a[href = ?]', renew_offer_path(@o_active), count: 0
    assert_select 'a[href = ?]', accept_offer_path(@o_active), count: 0
  end
  
  test "show for logged owner user" do
    log_in_as(@user1)
    get :show, id: @o_active.id
    assert_response :success
    assert_select 'a[href = ?]', edit_offer_path(@o_active), count: 1
    assert_select 'a[href = ?]', close_offer_path(@o_active), count: 1
    assert_select 'a[href = ?]', offer_path(@o_active), text: I18n.t('links.destroy'), count: 1
    
    assert_select 'a[href = ?]', renew_offer_path(@o_active), count: 0 #because offer is active
    assert_select 'a[href = ?]', accept_offer_path(@o_active), count: 0
    
    @o_active.update_attribute(:status_id, 2) #closed
    get :show, id: @o_active.id
    assert_select 'a[href = ?]', renew_offer_path(@o_active), count: 1 #because offer is inactive
  end
  
  test "show for logged admin user" do
    log_in_as(@admin)
    get :show, id: @o_active.id
    assert_response :success
    assert_select 'a[href = ?]', edit_offer_path(@o_active), count: 1
    assert_select 'a[href = ?]', close_offer_path(@o_active), count: 1
    assert_select 'a[href = ?]', offer_path(@o_active), text: I18n.t('links.destroy'), count: 1
    
    assert_select 'a[href = ?]', renew_offer_path(@o_active), count: 0 #admin cannot renew offers
    assert_select 'a[href = ?]', accept_offer_path(@o_active), count: 0 # offer is not pending
    
    @o_active.update_attribute(:status_id, 2) #closed
    get :show, id: @o_active.id
    assert_select 'a[href = ?]', accept_offer_path(@o_active), count: 0 #admin cannot renew offers
    
    @o_active.update_attribute(:status_id, 0) #pending
    get :show, id: @o_active.id
    assert_select 'a[href = ?]', accept_offer_path(@o_active), count: 1
  end

  test "index for non logged" do
    get :index
    assert_response :success
    @offers = assigns(:offers)
    
    @offers.each do |offer|
      assert offer.status_id == 1
      assert_select 'a[href = ?]', edit_offer_path(offer), count: 0
    end
    get :index, {status: 2}
    @offers = assigns(:offers)
    @offers.each do |offer|
      assert offer.status_id == 1
      assert_select 'a[href = ?]', edit_offer_path(offer), count: 0
    end
    get :index, {c_id: 5, region: 'Śląskie'}
    @offers = assigns(:offers)
    @offers.each do |offer|
      assert offer.status_id == 1
      assert offer.category_id == 5
      assert offer.owner.region == 'Śląskie'
      assert_select 'a[href = ?]', edit_offer_path(offer), count: 0
    end
  end
  
  test 'index for logged user' do
    log_in_as(@user1)
    get :index
    assert_response :success
    @offers = assigns(:offers)
    
    @offers.each do |offer|
      assert offer.status_id == 1
      if offer.owner == @user1
        assert_select 'a[href = ?]', edit_offer_path(offer), count: 1
      else
        assert_select 'a[href = ?]', edit_offer_path(offer), count: 0
      end
    end
    get :index, {status: 2, c_id: 2}
    @offers = assigns(:offers)
    @offers.each do |offer|
      assert offer.status_id == 1
      if offer.owner == @user1
        assert_select 'a[href = ?]', edit_offer_path(offer), count: 1
      else
        assert_select 'a[href = ?]', edit_offer_path(offer), count: 0
      end
    end
  end
  
  test 'index for admin user' do
    log_in_as(@admin)
    get :index
    assert_response :success
    @offers = assigns(:offers)
    
    @offers.each do |offer|
      assert_select 'a[href = ?]', edit_offer_path(offer), count: 1
    end
    get :index, {status: 2, c_id: 2}
    @offers = assigns(:offers)
    @offers.each do |offer|
      assert offer.status_id == 2
      assert_select 'a[href = ?]', edit_offer_path(offer), count: 1
    end
  end
  
  test 'other user close/accept/renew offer' do
    log_in_as @user2
    patch :close, id: @o_active.id
    assert_redirected_to root_path
    @o_active.reload
    assert_equal 1, @o_active.status_id
    
    patch :renew, id: @o_closed.id
    assert_redirected_to root_path
    @o_closed.reload
    assert_equal 2,  @o_closed.status_id
    
    patch :accept, id: @o_pending.id
    assert_redirected_to root_path
    @o_pending.reload
    assert_equal 0,  @o_pending.status_id
  end
  
  test 'owner close/accept/renew offer' do
    log_in_as @user1
    patch :close, id: @o_active.id
    assert_redirected_to @o_active
    @o_active.reload
    assert_equal 2, @o_active.status_id
    
    patch :renew, id: @o_closed.id
    assert_redirected_to @o_closed
    @o_closed.reload
    assert_equal 0,  @o_closed.status_id
    
    patch :accept, id: @o_pending.id
    assert_redirected_to root_path
    @o_pending.reload
    assert_equal 0,  @o_pending.status_id
  end
  
  test 'admin close/accept/renew offer' do
    log_in_as @admin
    patch :close, id: @o_active.id
    assert_redirected_to @o_active
    @o_active.reload
    assert_equal 2, @o_active.status_id
    
    patch :renew, id: @o_closed.id
    assert_redirected_to root_path
    @o_closed.reload
    assert_equal 2,  @o_closed.status_id
    
    patch :accept, id: @o_pending.id
    assert_redirected_to @o_pending
    @o_pending.reload
    assert_equal 1,  @o_pending.status_id
  end
  
  test 'users offer delete' do
    assert_no_difference 'Offer.count' do
      delete :destroy, id: @o_active.id
      assert_redirected_to root_path
    end
    assert_no_difference 'Offer.count' do
      log_in_as @user2
      delete :destroy, id: @o_active.id
      assert_redirected_to root_path
    end
    assert_difference 'Offer.count', -1 do
      log_in_as @user1
      delete :destroy, id: @o_active.id
      assert_redirected_to @user1
    end
    assert_difference 'Offer.count', -1 do
      log_in_as @admin
      delete :destroy, id: @o_pending.id
      assert_redirected_to @user1
    end
    
  end
  

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user1)
    get :edit, id: @o_active.id
    assert_response :success
  end

end
