class CreateSystemAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :system_attributes do |t|
      t.string :name
      t.string :value
    end
  end
end
