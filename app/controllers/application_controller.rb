class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  SITE_NAME = "ClockOut"

  private 

  def not_found
    redirect_to :status => 404
  end

  # 非本站用户请速去登录
  def has_logined
    return redirect_to login_url unless session[:user_id]
  end

  def push_navbar_info_to_session(user)
    session[:name] = user.name
    session[:num] = user.current_missions
  end

  def pop_session_info_to_navbar
    if session[:user_id]
      @navbar = Navbar.new(session[:user_id], session[:name], session[:num])
      @navbar.name ||= ''
      @navbar.num ||= 0
    else
      @navbar = nil
    end
  end

  def clean_sessions
    session[:user_id] = nil
    session[:name] = nil
    session[:num] = nil
  end

end
