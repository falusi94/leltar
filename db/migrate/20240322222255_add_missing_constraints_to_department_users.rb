class AddMissingConstraintsToDepartmentUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :department_users, :user_id, false
    change_column_null :department_users, :department_id, false
    change_column_default :department_users, :write, from: nil, to: false
  end
end
