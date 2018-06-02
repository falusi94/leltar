class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  def unauthorized_page
    render 'application/401', status: :unauthorized
  end

  def set_groups
    if current_user.admin
      @groups = Group.all.order(:name)
    else
      @groups = Group.order(:name).can_read(current_user.id)
    end
  end

  def require_admin
    return unauthorized_page unless current_user.admin
  end

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end
  helper_method :current_user

  def require_login
    redirect_to login_path, redirect: request.original_fullpath unless session[:user_id]
  end

end
