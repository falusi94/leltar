class CreateRights < ActiveRecord::Migration[5.0]
  def change
    create_table :rights do |t|
      t.integer :user_id
      t.integer :group_id
      t.boolean :write

      t.timestamps
    end
  end
end
