# frozen_string_literal: true

module Authentication
  Error                = Class.new(StandardError)
  InvalidTokenError    = Class.new(Error)
  InvalidUserError     = Class.new(Error)
  InvalidClientError   = Class.new(Error)
  InvalidPasswordError = Class.new(Error)

  Token = Struct.new(:user_id, :client_id, :created_at)

  def self.validate_token(...)
    TokenValidator.execute(...)
  end
end
