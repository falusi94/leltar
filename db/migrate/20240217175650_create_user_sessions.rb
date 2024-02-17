class CreateUserSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :client_id, index: true
      t.string :user_agent, limit: 512
      t.string :ip_address
      t.datetime :last_used, null: false

      t.timestamps
    end
  end
end
