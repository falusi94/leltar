class AddAllReadWriteRightsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :read_all_group, :boolean, default: false
    add_column :users, :write_all_group, :boolean, default: false
  end
end
