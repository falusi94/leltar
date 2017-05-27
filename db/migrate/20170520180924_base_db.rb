class BaseDb < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name

      t.timestamps
    end
    create_table :items do |t|
      t.string :name
      t.string :description
      t.date :purchase_date
      t.date :entry_date
      t.date :last_check
      t.string :status
      t.integer :old_number
      t.belongs_to :group
      t.timestamps
    end
    create_table :photos do |t|
      t.timestamps
      t.attachment :file
      t.belongs_to :item, index: true
    end
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :read_rights
      t.string :write_rights
      t.boolean :admin
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
