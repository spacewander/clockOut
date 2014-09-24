# 会话控制器，管理用户登录和登出
class SessionsController < ApplicationController
  before_filter :check_session_timeout, only: [:index]

  # GET / 
  def index
    if user_id = session[:user_id]
      redirect_to user_path(user_id)
    else
      redirect_to login_url
    end
  end

  # GET /login
  def new
    render 
  end

  # POST /login
  def create
    @user = User.authenticate(params[:name], params[:password])
    if @user
      expire_session_after_visit if !params[:remember_me]
      session[:user_id] = @user.id
      push_navbar_info_to_session(@user)
      return redirect_to :back if params[:back]

      redirect_to user_path(@user.id)
    else
      redirect_to login_url, :notice => '用户名或密码错误'
    end
  end

  # DELETE /logout
  def destroy
    clean_sessions
    redirect_to login_url
  end

  private

  def expire_session_after_visit
    session[:last_seen] = Time.now
  end

end
