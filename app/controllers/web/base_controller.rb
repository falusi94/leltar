# frozen_string_literal: true

module Web
  class BaseController < ApplicationController
    rescue_from Pundit::NotAuthorizedError, with: :unauthorized_page
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_page

    include Pagy::Backend

    before_action :require_login

    def unauthorized_page
      render 'application/401', status: :unauthorized
    end

    def not_found_page
      render 'application/404', status: :not_found
    end

    def set_departments
      @departments = current_user.read_departments.order(:name)
      @write_departments = current_user.write_departments
    end

    def current_user
      @current_user ||= session[:user_id] && User.find(session[:user_id])
    end
    helper_method :current_user

    def require_login
      return if session[:user_id]

      redirect_url = Organization.any? ? new_session_path : new_setup_user_path
      redirect_to redirect_url, redirect: request.original_fullpath
    end
  end
end
