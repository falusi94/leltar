class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.date :purchase_date
      t.date :entry_date
      t.date :last_check
      t.string :status
      t.integer :old_number

      t.timestamps
    end
  end
end
