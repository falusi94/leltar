class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:smart_redirect]

  def new
    @redirect = params[:redirect]
    @notice = params[:notice]
  end

  def create
    user = User.where(email: session_params[:email]).first
    redirect_url = session_params[:redirect] || '/'
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      return redirect_to redirect_url
    end
    redirect_to new_session_path, redirect: redirect_url, alert: 'Hibás bejelentkezési adatok'
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end

  def session_params
    params.require(:session).permit(:email, :password, :redirect)
  end
end
