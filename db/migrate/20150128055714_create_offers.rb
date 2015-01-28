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
    add_index :offers, :category_id
    add_index :offers, :status_id
    add_index :offers, :valid_until, order: {valid_until: :desc}
  end
end
