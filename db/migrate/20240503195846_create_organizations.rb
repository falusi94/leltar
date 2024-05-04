class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :currency_code, null: false
      t.string :slug, null: false, index: true

      t.date :fiscal_period_starts_at
      t.string :fiscal_period_unit

      t.jsonb :depreciation_config, default: {}

      t.timestamps
    end
  end
end
