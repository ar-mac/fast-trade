class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :progress, default: 0, null: false

      t.timestamps
    end
  end
end
