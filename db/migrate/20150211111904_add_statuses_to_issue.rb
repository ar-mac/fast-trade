class AddStatusesToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :active_for_sender, :boolean, default: true
    add_column :issues, :active_for_reciever, :boolean, default: true
    
    add_index :issues, :offer_id
  end
end
