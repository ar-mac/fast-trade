class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :name_id

      t.timestamps
    end
  end
end
