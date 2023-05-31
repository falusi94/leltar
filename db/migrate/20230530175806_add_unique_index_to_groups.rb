class AddUniqueIndexToGroups < ActiveRecord::Migration[7.0]
  def change
    add_index :groups, :name, unique: true
  end
end
