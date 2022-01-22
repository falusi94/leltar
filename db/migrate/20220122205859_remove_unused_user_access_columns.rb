class RemoveUnusedUserAccessColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :read_rights
    remove_column :users, :write_rights
  end
end
