class DropDepreciationConfigFromOrganizations < ActiveRecord::Migration[7.1]
  def change
    remove_column :organizations, :depreciation_config, :jsonb, default: {}
  end
end
