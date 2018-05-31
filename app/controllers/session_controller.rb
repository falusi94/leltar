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
        session[:user_id] = user.id
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
    reset_session
    redirect_to controller: 'session', action: 'new'
  end

  def smart_redirect
    if !current_user
      redirect_to controller: 'session', action: 'new'
    elsif current_user.can_read?('all')
      redirect_to controller: 'items', action: 'index'
    else
      groups = current_user.read_groups
      if groups.size != 1
        redirect_to controller: 'items', action: 'group_index'
      else
        redirect_to controller: 'items', action: 'group_show', grp: groups[0]
      end
    end
  end

  def session_params
    params.require(:session).permit(:email, :password, :redirect)
  end
end
