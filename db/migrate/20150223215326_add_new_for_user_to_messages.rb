class AddNewForUserToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :new_for_user_id, :integer, {index: true}
  end
end
