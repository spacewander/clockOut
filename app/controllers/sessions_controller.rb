# 会话控制器，管理用户登录和登出
class SessionsController < ApplicationController
  # GET / 
  def index
    if session[:user_id]
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
    user = User.authenticate(params[:name], params[:password])
    if user
      session[:user_id] = user.id
      return redirect_to :back if params[:back]

      redirect_to user_path(user.id)
    else
      redirect_to login_url, :notice => '用户名或密码错误'
    end
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil
    redirect_to login_url
  end

end
