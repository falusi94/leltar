class AddForeignKeyToRights < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :rights, :groups
    add_foreign_key :rights, :users
  end
end
