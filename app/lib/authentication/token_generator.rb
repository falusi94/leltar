# frozen_string_literal: true

module Authentication
  class TokenGenerator
    attr_reader :user_id, :client_id

    def initialize(user_id, client_id)
      @user_id   = user_id
      @client_id = client_id
    end

    def self.generate(...)
      new(...).generate
    end

    def generate
      JWT.encode(payload, secret_key_base, 'HS256')
    end

    private

    def payload
      {
        user_id:    user_id,
        exp:        expiration_time,
        client_id:  client_id,
        created_at: Time.zone.now.to_i
      }
    end

    def expiration_time
      4.hours.from_now.to_i
    end

    def secret_key_base
      Rails.application.credentials.secret_key_base
    end
  end
end
