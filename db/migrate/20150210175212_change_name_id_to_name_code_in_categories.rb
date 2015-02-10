class ChangeNameIdToNameCodeInCategories < ActiveRecord::Migration
  def up
    remove_column :categories, :name_id, :integer
    add_column :categories, :name_code, :string
  end
  def down
    remove_column :categories, :name_code, :string
    add_column :categories, :name_id, :integer
  end
end
