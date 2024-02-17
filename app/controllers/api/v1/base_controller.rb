# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      rescue_from Pundit::NotAuthorizedError, with: -> { head :unauthorized }
      rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }

      include Pagy::Backend
      include Pundit::Authorization
      include Authentication::ControllerMixin

      helper_method :pagy_jsonapi_links

      after_action :verify_authorized
      before_action :authenticate_user!

      def authenticate_user!
        authenticate!(User.includes(:sessions))
      end
    end
  end
end
