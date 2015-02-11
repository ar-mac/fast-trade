class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :sender_id
      t.integer :reciever_id
      t.integer :offer_id
      t.string :title

      t.timestamps
    end
  end
end
