class UpdateItemFields < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :old_number, :integer
    remove_column :items, :status, :integer
    rename_column :items, :state, :status

    change_table :items do |t|
      t.integer :number, default: 1
      t.integer :parent, references: :items
      t.string :specific_name
      t.string :serial
      t.string :location
      t.string :at_who
      t.integer :condition, default: 0
      t.date :warranty, default: nil
      t.string :comment
      t.string :inventory_number
      t.integer :entry_price
      t.integer :accountancy_state, default: 0
    end
  end
end
