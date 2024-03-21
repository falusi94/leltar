class RenameRightToDepartmentUser < ActiveRecord::Migration[7.1]
  def change
    rename_table :rights, :department_users
  end
end
