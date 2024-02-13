# frozen_string_literal: true

module Authentication
  class TokenDecoder
    def initialize(jwt)
      @jwt   = jwt
      @token = Token.new
    end

    def self.parse(...)
      new(...).parse
    end

    def parse
      token.user_id    = payload['user_id']
      token.client_id  = payload['client_id']
      token.created_at = payload['created_at']

      Rails.logger.info("[Authentication] Token: #{token}")

      token
    end

    private

    attr_reader :jwt, :token

    def payload
      @payload ||= JWT.decode(jwt, secret_key_base, true, algorithm: 'HS256').first
    end

    def secret_key_base
      Rails.application.credentials.secret_key_base
    end
  end
end
