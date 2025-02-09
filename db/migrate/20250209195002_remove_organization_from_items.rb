class RemoveOrganizationFromItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :organization, :string
  end
end
