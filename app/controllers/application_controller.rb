# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized_page

  protect_from_forgery with: :exception
  before_action :require_login

  def unauthorized_page
    render 'application/401', status: :unauthorized
  end

  def set_groups
    @groups = current_user.read_groups.order(:name)
    @write_groups = current_user.write_groups
  end

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end
  helper_method :current_user

  def require_login
    redirect_to new_session_path, redirect: request.original_fullpath unless session[:user_id]
  end
end
