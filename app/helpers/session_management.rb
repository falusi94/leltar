module SessionManagement
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session[:user_id] = nil
  end

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def require_login
    if !logged_in?
      redirect_to controller: 'session', action: 'new', redirect: request.original_fullpath
    end
  end

  def require_read(object)
    if current_user.can_read?(object)
      yield
    else
      render status: 401, inline: "Unathorized"
    end
  end

  def require_write(object)
    if current_user.can_write?(object)
      yield
    else
      render status: 401, inline: "Unathorized"
    end
  end

end
