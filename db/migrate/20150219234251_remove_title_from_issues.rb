class RemoveTitleFromIssues < ActiveRecord::Migration
  def up
    remove_column :issues, :title, :string
  end
  
  def down
    add_column :issues, :title, :string
  end
end
