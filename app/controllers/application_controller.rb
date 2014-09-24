require 'digest/sha2'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from CanCan::AccessDenied do |exception|
    @error_message = exception.message
    respond_to do |format|
      format.json { render :err }
      format.html { redirect_to login_path }
    end
  end

  private 

  def not_found
    return redirect_to :status => 404
  end

  def forbidden
    return respond_to do |format|
      format.json { render json: {:msg => "unauthentication"}, 
                    status: :forbidden}
      format.html { redirect_to login_path }
    end
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
    reset_session
  end

  # 当用户需要“忘记我”的时候，设置一个last_seen并确保其不能超过当前时间的一天前
  def check_session_timeout
    if session[:last_seen] && ((Time.now - session[:last_seen]) / 1.days).round > 1
      reset_session
      return redirect_to login_path
    end
  end

end
