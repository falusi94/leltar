class SanitizeItemAttributes < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :comment, :string
    remove_column :items, :at_who, :string
    remove_column :items, :specific_name, :string

    rename_column :items, :number, :count
    rename_column :items, :serial, :serial_number
    rename_column :items, :warranty, :warranty_end_at
    rename_column :items, :purchase_date, :acquisition_date

    add_column :items, :acquisition_type, :string

    add_index :items, :name
    add_index :items, :description
    add_index :items, :serial_number
    add_index :items, :inventory_number

    change_column_null :items, :name, false
  end
end
