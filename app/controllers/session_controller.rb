class SessionController < ApplicationController
  skip_before_action :require_login, except: [:smart_redirect]

  def new
    @redirect = params[:redirect]
    @notice = params[:notice]
  end

  def create
    user = User.where(email: session_params[:email]).first
    redirect_url = session_params[:redirect] || '/'
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      return redirect_to redirect_url
    end
    redirect_to login_path, redirect: redirect_url, alert: 'Hibás bejelentkezési adatok'
  end

  def destroy
    reset_session
    redirect_to login_path
  end

  def smart_redirect
    return redirect_to items_path if current_user.admin

    groups = current_user.groups
    return unauthorized_page if groups.size == 0
    return redirect_to items_path if groups.size > 1
    redirect_to items_path, group_id: groups[0].id
  end

  def session_params
    params.require(:session).permit(:email, :password, :redirect)
  end
end
