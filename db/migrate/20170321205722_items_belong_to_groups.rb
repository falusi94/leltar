class ItemsBelongToGroups < ActiveRecord::Migration[5.0]
  def change
    change_table :items do |t|
      t.belongs_to :group, index: true
    end
  end
end
