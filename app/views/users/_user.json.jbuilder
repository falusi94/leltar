json.extract! user, :id, :name, :email, :password_hash, :read_rights, :write_rights, :admin, :created_at, :updated_at
json.url user_url(user, format: :json)