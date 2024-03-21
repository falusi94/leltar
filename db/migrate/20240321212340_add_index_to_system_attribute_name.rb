class AddIndexToSystemAttributeName < ActiveRecord::Migration[7.1]
  def change
    add_index :system_attributes, :name, unique: true
  end
end
