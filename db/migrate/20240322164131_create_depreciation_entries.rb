class CreateDepreciationEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :depreciation_entries do |t|
      t.references :depreciation_details, null: false, foreign_key: true
      t.date :period_start_date, null: false
      t.date :period_end_date, null: false
      t.integer :depreciation_expense, null: false
      t.integer :accumulated_depreciation, null: false
      t.integer :book_value, null: false

      t.timestamps
    end
  end
end
