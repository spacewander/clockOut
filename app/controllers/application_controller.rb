class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private 

  def not_found
    redirect_to :status => 404
  end

  # 非本站用户请速去登录
  def has_logined
    return redirect_to login_url unless session[:user_id]
  end

end
