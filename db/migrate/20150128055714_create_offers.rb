class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :title
      t.text :content
      t.date :valid_until
      t.integer :status_id
      t.integer :category_id
      t.integer :user_id

      t.timestamps
    end
  end
end
