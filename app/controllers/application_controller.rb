class ApplicationController < ActionController::Base
  include SessionManagement
  protect_from_forgery with: :exception
  before_action :require_login

  def unauthorized_page
    render 'application/401', status: :unauthorized
  end

  def set_groups
    if current_user.admin
      @groups = Group.all
    else
      @groups = Group.can_write(current_user.id)
    end
  end

  def require_admin
    return unauthorized_page unless current_user.admin
  end
end
