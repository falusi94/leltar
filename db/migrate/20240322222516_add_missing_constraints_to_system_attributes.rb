class AddMissingConstraintsToSystemAttributes < ActiveRecord::Migration[7.1]
  def change
    change_column_null :system_attributes, :name, false
    change_column_null :system_attributes, :value, false
  end
end
