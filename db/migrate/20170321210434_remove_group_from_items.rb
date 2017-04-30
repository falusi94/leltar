class RemoveGroupFromItems < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :group, :string
  end
end
