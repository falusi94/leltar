class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
