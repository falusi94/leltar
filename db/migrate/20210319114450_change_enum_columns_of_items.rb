class ChangeEnumColumnsOfItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :items, :status, type: :integer
    remove_column :items, :condition, type: :integer
    remove_column :items, :accountancy_state, type: :integer
    remove_column :items, :organization, type: :integer

    add_column :items, :status, :string
    add_column :items, :condition, :string
    add_column :items, :accountancy_state, :string
    add_column :items, :organization, :string

    add_index :items, :status
    add_index :items, :condition
    add_index :items, :accountancy_state
  end
end
