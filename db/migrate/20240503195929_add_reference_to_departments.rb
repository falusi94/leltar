class AddReferenceToDepartments < ActiveRecord::Migration[7.1]
  def change
    add_reference :departments, :organization
  end
end
