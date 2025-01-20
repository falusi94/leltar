class CreateDepreciationConfigs < ActiveRecord::Migration[7.1]
  def change
    create_table :depreciation_configs do |t|
      t.string :depreciation_method, null: false
      t.integer :depreciation_frequency_value, null: false
      t.string :depreciation_frequency_unit, null: false
      t.boolean :automatic_depreciation, null: false
      t.integer :automatic_depreciation_useful_life, null: false
      t.integer :automatic_depreciation_salvage_value, null: false
      t.references :organization, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
