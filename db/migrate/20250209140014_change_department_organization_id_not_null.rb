class ChangeDepartmentOrganizationIdNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :departments, :organization_id, false
  end
end
