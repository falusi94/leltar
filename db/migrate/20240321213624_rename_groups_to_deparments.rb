class RenameGroupsToDeparments < ActiveRecord::Migration[7.1]
  def change
    rename_table :groups, :departments
    rename_column :items, :group_id, :department_id
    rename_column :rights, :group_id, :department_id
    rename_column :users, :read_all_group, :read_all_department
    rename_column :users, :write_all_group, :write_all_department
  end
end
