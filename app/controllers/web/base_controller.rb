# frozen_string_literal: true

module Web
  class BaseController < ApplicationController
    rescue_from Pundit::NotAuthorizedError, with: :unauthorized_page
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_page

    include Pagy::Backend
    include Authorization::ControllerMixin
    include DefaultOrganizationUrlOptions

    before_action :require_login
    after_action :verify_authorized

    def unauthorized_page
      render 'application/401', status: :unauthorized
    end

    def not_found_page
      render 'application/404', status: :not_found
    end

    def set_departments
      @departments = policy_scope(Department).order(:name)
      @write_departments = current_user.departments.with_write_access.where(organization: current_organization)
    end

    def current_user
      @current_user ||= session[:user_id] && User.find(session[:user_id])
    end
    helper_method :current_user

    def current_organization
      @current_organization ||= organizations.find_by!(slug: params[:organization_slug])
    end
    helper_method :current_organization

    def organizations
      OrganizationPolicy::Scope.new(Authorization::Scope.new(user: current_user), Organization).resolve
    end
    helper_method :organizations

    def require_login
      return if session[:user_id]

      params[:organization_slug] = nil
      redirect_url = Organization.any? ? new_session_path : new_setup_user_path
      redirect_to redirect_url, redirect: request.original_fullpath
    end
  end
end
