# frozen_string_literal: true

module Authentication
  module ControllerMixin
    extend ActiveSupport::Concern

    included do
      attr_reader :current_user

      def authenticate!(user_class)
        jwt                   = request.headers['access-token']
        new_jwt, user, _token = Authentication.validate_token(jwt: jwt, user_class: user_class)

        @current_user = user

        response.headers['access-token'] = new_jwt
      rescue Authentication::Error
        head :unauthorized
      end

      def remove_user_client(user_class)
        jwt                   = request.headers['access-token']
        _new_jwt, user, token = Authentication.validate_token(jwt: jwt, user_class: user_class)

        user.remove_client(token.client_id)
      end
    end
  end
end
