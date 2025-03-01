# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      rescue_from Pundit::NotAuthorizedError, with: -> { head :forbidden }
      rescue_from ActiveRecord::RecordNotFound, with: -> { head :not_found }

      include Pagy::Backend
      include Pundit::Authorization
      include Authentication::ControllerMixin
      include Authorization::ControllerMixin

      helper_method :pagy_jsonapi_links

      after_action :verify_authorized
      before_action :authenticate_user!

      def current_organization
        @current_organization ||= organizations.find(params[:organization_id]) if params[:organization_id]
      end

      def organizations
        OrganizationPolicy::Scope.new(Authorization::Scope.new(user: current_user), Organization).resolve
      end

      def authenticate_user!
        authenticate!(User.includes(:sessions))
      end
    end
  end
end
