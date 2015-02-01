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
  

  test "new offer action" do
    get :new
    assert_redirected_to login_path
    
    log_in_as @user1
    get :new
    assert_response :success
    assert_template 'new'
    @o_new = assigns(:offer)
    assert_not_nil @o_new
  end
  
  test 'valid create offer action' do
    log_in_as @user1
    post :create, offer: {
      title: 'Valid new offer title',
      valid_until: (Time.zone.today + 10.days),
      category_id: 4,
      content: Faker::Lorem.sentence(6)
    }
    @o_new = assigns(:offer)
    assert_redirected_to offer_path(@o_new)
    assert_equal 0, @o_new.status_id
  end
  
  test 'create offer action with attempt to set status' do
    log_in_as @user1
    post :create, offer: {
      title: 'Valid other new offer title',
      valid_until: (Time.zone.today + 10.days),
      category_id: 4,
      content: Faker::Lorem.sentence(6),
      status_id: 1
    }
    @o_new = assigns(:offer)
    assert_redirected_to offer_path(@o_new)
    assert_equal 0, @o_new.status_id
  end

  test "edit permissions" do
    get :edit, id: @o_active.id
    assert_response :redirect
    
    log_in_as @user2
    get :edit, id: @o_active.id
    assert_response :redirect
    
    log_in_as @user1
    get :edit, id: @o_active.id
    assert_response :success
    assert_not_nil assigns(:offer)
    
    log_in_as @admin
    get :edit, id: @o_active.id
    assert_response :success
    assert_not_nil assigns(:offer)
  end
  
  test 'full update with valid params' do
    newtitle = 'Changed title for offer'
    newcontent = Faker::Lorem.sentence(5)
    log_in_as @user1
    patch :update, id: @o_active, offer: {
      title: newtitle,
      valid_until: (Time.zone.today + 10.days),
      category_id: 7,
      content: newcontent
    }
    @o_edited = assigns(:offer)
    assert_redirected_to @o_edited
    assert_equal newtitle, @o_edited.title
    assert_equal((Time.zone.today + 10.days), @o_edited.valid_until)
    assert_equal 7, @o_edited.category_id
    assert_equal newcontent, @o_edited.content
    assert_equal 0, @o_edited.status_id
  end
  
  test 'full update with invalid params' do
    newtitle = 'Short'
    newcontent = Faker::Lorem.sentence(5)
    
    log_in_as @user1
    patch :update, id: @o_active, offer: {
      title: newtitle,
      valid_until: (Time.zone.today - 2.days),
      category_id: 25,
      content: newcontent
    }
    @o_edited = assigns(:offer)
    assert_template 'edit'
  end

end
