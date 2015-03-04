require 'test_helper'

class SearchFormsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :tom
    @admin = users :admin
    @max_date = Date.today + 4.days
    @min_date = Date.today + 2.days
    @category = Category.find(rand(1..11))
    @region = User::REGIONS[rand(0..15)]
  end
  
  test 'offer_search form date' do
    log_in_as @user
    get "/#{I18n.locale}/offers", 
      d_max: {
        "(3i)".to_sym => @max_date.day,
        "(2i)".to_sym => @max_date.month,
        "(1i)".to_sym => @max_date.year
        },
      d_min: {
        "(3i)".to_sym => @min_date.day,
        "(2i)".to_sym => @min_date.month,
        "(1i)".to_sym => @min_date.year
        }
        
    @offers = assigns :offers
    @offers.each do |offer|
      assert offer.valid_until >= @min_date, "valid_until: #{offer.valid_until} should be greater than min_date: #{@min_date}"
      assert offer.valid_until <= @max_date, "valid_until: #{offer.valid_until} should be less than max_date: #{@max_date}"
    end
    
    get "/#{I18n.locale}/offers",
      c_id: @category.id
      
    @offers = assigns :offers
    @offers.each do |offer|
      assert offer.category == @category, "offer.category: #{offer.category} should be equal c_id: #{@category}"
    end
    
    get "/#{I18n.locale}/offers",
      region: @region
      
    @offers = assigns :offers
    @offers.each do |offer|
      assert offer.owner.region == @region, "offer.owner.region: #{offer.owner.region} should be equal region: #{@region}"
    end
    
    get "/#{I18n.locale}/offers",
      status: 0
      
    @offers = assigns :offers
    @offers.each do |offer|
      assert offer.status_id == 1, "offer.status: #{offer.status} should be equal to 1"
    end
    
    get "/#{I18n.locale}/offers",
      price_min: 15,
      price_max: 40
      
    @offers = assigns :offers
    @offers.each do |offer|
      assert offer.price >= 15 && offer.price <= 40, "offer.price: #{offer.price} should be within range 15..40"
    end
    
    log_in_as @admin
    get "/#{I18n.locale}/offers",
      status: 0
      
    @offers = assigns :offers
    @offers.each do |offer|
      assert offer.status_id == 0, "offer.status: #{offer.status_id} should be equal to 0"
    end
  end
end
