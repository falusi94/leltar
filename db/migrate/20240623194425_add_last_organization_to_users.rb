class AddLastOrganizationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_organization_id, :bigint
    add_index :users, :last_organization_id
    add_foreign_key :users, :organizations, column: :last_organization_id
  end
end
