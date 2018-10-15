class RenameItemParentToParentId < ActiveRecord::Migration[5.0]
  def change
    rename_column :items, :parent, :parent_id
  end
end
