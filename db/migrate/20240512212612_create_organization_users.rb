class CreateOrganizationUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :role_name, null: false, default: 'user', index: true

      t.timestamps
    end
  end
end
