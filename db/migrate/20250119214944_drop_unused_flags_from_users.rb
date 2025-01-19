class DropUnusedFlagsFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :read_all_department, :boolean, default: false
    remove_column :users, :write_all_department, :boolean, default: false
  end
end
