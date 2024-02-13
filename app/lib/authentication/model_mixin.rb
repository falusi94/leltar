# frozen_string_literal: true

module Authentication
  module ModelMixin
    extend ActiveSupport::Concern

    TOKEN_LIMIT = 10

    included do # rubocop:disable Metrics/BlockLength
      has_secure_password

      def api_authenticate(password_param, user_agent:, ip_address:)
        raise InvalidPasswordError unless authenticate(password_param)

        client_id = SecureRandom.uuid

        add_client(client_id, user_agent, ip_address)
        update!(last_sign_in_at: Time.zone.now)

        generate_jwt(client_id)
      end

      def generate_jwt(client_id)
        Authentication::TokenGenerator.generate(id, client_id)
      end

      def remove_client(client_id)
        sessions.find_by!(client_id: client_id).destroy
      end

      def clients
        sessions.select(:client_id).order(created_at: :asc).pluck(:client_id)
      end

      def update_session(client_id)
        sessions.find_by!(client_id: client_id).update!(last_used: Time.zone.now)
      end

      private

      def add_client(client_id, user_agent, ip_address)
        sessions.create!(client_id: client_id, user_agent: user_agent, last_used: Time.zone.now, ip_address: ip_address)

        purge_sessions
      end

      def purge_sessions
        return if sessions.size < TOKEN_LIMIT

        ids = clients
        ids.pop(TOKEN_LIMIT)
        sessions.where(client_id: ids).destroy_all
      end
    end
  end
end
