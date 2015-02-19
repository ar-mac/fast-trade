class AddIndexToIssues < ActiveRecord::Migration
  def change
    add_index :issues, :sender_id
    add_index :issues, :reciever_id
  end
end
