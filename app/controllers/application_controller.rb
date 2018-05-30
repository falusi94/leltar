class ApplicationController < ActionController::Base
  include SessionManagement
  protect_from_forgery with: :exception
  before_action :require_login

  def unauthorized_page
    render 'application/401', status: :unauthorized
  end
end
