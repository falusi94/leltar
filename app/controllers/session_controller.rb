class SessionController < ApplicationController
  skip_before_action :require_login
  def new
    @redirect = params[:redirect]
    @notice = params[:notice]
  end

  def create
    user = User.where(email: session_params[:email]).first
    redirect_url = session_params[:redirect] || '/'
    if user
      if user.authenticate(session_params[:password])
        log_in(user)
        redirect_to redirect_url
      else
        redirect_to controller: 'session', action: 'new',
          redirect: redirect_url, notice: 'Rossz email vagy jelszo'
      end
    else
        redirect_to controller: 'session', action: 'new',
          redirect: redirect_url, notice: 'Rossz email vagy jelszo'
    end
  end

  def destroy
  end

  def session_params
    params.require(:session).permit(:email, :password, :redirect)
  end
end
