class ChangeLocationReferenceInItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :location, :string
    add_reference :items, :location
  end
end
