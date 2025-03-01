# frozen_string_literal: true

module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_user!, only: %i[create destroy]
      skip_after_action :verify_authorized

      def create
        @user = User.find_by!(email: params[:email])
        token = @user.api_authenticate(params[:password], user_agent: request.user_agent, ip_address: request.ip)

        response.headers['Authorization'] = "Bearer #{token}"
      rescue ActiveRecord::RecordNotFound, Authentication::Error
        head :unauthorized
      end

      def destroy
        remove_user_client(User)

        head :ok
      rescue Authentication::Error
        head :unauthorized
      end
    end
  end
end
