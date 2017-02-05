class AddGroup < ActiveRecord::Migration[5.0]
  def change
    change_table :items do |t|
      t.string :group
    end
  end
end
