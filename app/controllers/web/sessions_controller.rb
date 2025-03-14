# frozen_string_literal: true

module Web
  class SessionsController < BaseController
    skip_before_action :require_login, only: %i[new create]
    skip_after_action :verify_authorized

    def new
      @redirect = params[:redirect]
      @notice = params[:notice]
    end

    def create
      user = User.find_by(email: session_params[:email])
      redirect_url = session_params[:redirect] || '/'
      if user&.authenticate(session_params[:password])
        session[:user_id] = user.id
        return redirect_to redirect_url
      end
      redirect_to new_session_path, redirect: redirect_url, alert: t(:invalid_credentials)
    end

    def destroy
      reset_session
      redirect_to new_session_path
    end

    private

    def session_params
      params.require(:session).permit(:email, :password, :redirect)
    end
  end
end
