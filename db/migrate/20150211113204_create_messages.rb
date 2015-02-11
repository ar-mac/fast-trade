class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :issue_id
      t.datetime :read_at

      t.timestamps
    end
    add_index :messages, :issue_id
  end
end
