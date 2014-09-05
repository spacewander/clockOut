class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :pop_session_info_to_navbar, only: [:show, :edit, :index]

  # 各种操作（除了创建用户以外）都需要用户登录
  before_filter :has_logined, except: [:new, :create]
  # 有些操作只允许对自己的页面进行
  before_filter :is_hoster, only: [:edit, :update, :destroy]

  layout 'user'

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name)

    respond_to do |format|
      format.html
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    # 找不到该用户
    return not_found() unless @user
    
    # 是访客而非页面的主人
    @user.is_visitor = true if session[:user_id] != params[:id]
    
    render
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if lastUser = User.all().last()
      @user.member_no = lastUser.id
    else
      @user.member_no = 0
    end
    @user.member_no += 1
    @user.join_date = Date.today.to_s

    @user.sex = "" if @user.sex.nil? # 设置为默认值

    respond_to do |format|
      if @user.save
        # 注册后先登录再说
        format.html { redirect_to login_url}
        format.json { render :show, status: :created, location: @user }
      else
        #puts @user.errors.full_messages
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        push_navbar_info_to_session(@user)
        format.html { redirect_to action: 'show', :id => @user.to_param}
        format.json { render :show, status: :ok, location: @user }
      else
        #puts @user.errors.full_messages
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    clean_sessions
    respond_to do |format|
      format.html { redirect_to users_url, notice: '用户已成功注销' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :name, :sex, :year, :date, 
                                   :password, :password_confirmation, :email)
    end

    # 只有是页面主人才能提交修改
    def is_hoster
      if session[:user_id] != params[:id]
        respond_to do |format|
          format.json { render json: {:msg => "unauthentication"}, 
                        status: :forbidden}
          format.html { redirect_to :status => :forbidden  }
        end
        return
      end
    end

end
