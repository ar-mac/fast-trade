require 'test_helper'

class OffersControllerTest < ActionController::TestCase
  
  def setup
    @o_1 = offers(:offer_1)
    @o_1_owner = @o_1.owner
  end
  
  test "should get show" do
    get :show, id: @o_1.id
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@o_1_owner)
    get :edit, id: @o_1.id
    assert_response :success
  end

end
