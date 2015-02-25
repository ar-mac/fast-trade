class AddPriceToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :price, :integer, default: nil
  end
end
