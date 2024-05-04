class CreateDepreciationDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :depreciation_details do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :useful_life, null: false
      t.integer :entry_value, null: false
      t.date :entry_date, null: false
      t.integer :book_value, null: false
      t.integer :salvage_value, null: false
      t.string :depreciation_method, null: false
      t.string :depreciation_frequency_unit, null: false
      t.integer :depreciation_frequency_value, null: false

      t.timestamps
    end
  end
end
