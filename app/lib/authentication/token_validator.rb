# frozen_string_literal: true

module Authentication
  class TokenValidator
    def initialize(jwt:, user_class:)
      @jwt        = jwt
      @user_class = user_class
    end

    def self.execute(...)
      new(...).execute
    end

    def execute
      decode_token
      find_user
      validate_client
      update_user_session

      [update_jwt, user, decoded_token]
    rescue JWT::ExpiredSignature, JWT::DecodeError
      raise InvalidTokenError
    rescue ActiveRecord::RecordNotFound
      raise InvalidUserError
    end

    private

    attr_reader :user, :jwt, :user_class, :decoded_token

    def decode_token
      @decoded_token = TokenDecoder.parse(jwt)
    end

    def find_user
      @user = user_class.find(decoded_token.user_id)
    end

    def validate_client
      raise InvalidClientError if user.clients.exclude?(decoded_token.client_id)
    end

    def update_user_session
      user.update_session(decoded_token.client_id)
    end

    def update_jwt
      user.generate_jwt(decoded_token.client_id)
    end
  end
end
