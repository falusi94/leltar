class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  def unauthorized_page
    render 'application/401', status: :unauthorized
  end

  def set_groups
    @groups = current_user.read_groups.order(:name)
    @write_groups = current_user.write_groups
  end

  def require_admin
    return unauthorized_page unless current_user.admin
  end

  def require_group_write
    @item ||= Item.find(params[:item_id])
    return unauthorized_page unless current_user.can_write?(@item.group_id)
  end

  def require_group_read
    @item ||= Item.find(params[:item_id])
    return unauthorized_page unless current_user.can_read?(@item.group_id)
  end

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end
  helper_method :current_user

  def require_login
    redirect_to login_path, redirect: request.original_fullpath unless session[:user_id]
  end
end
