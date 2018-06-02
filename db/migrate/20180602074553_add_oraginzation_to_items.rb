class AddOraginzationToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :organization, :integer, default: 0
  end
end
