class UsersController < ApplicationController
  before_action :set_user_with_params, only: [:show, :edit, :update, :destroy,
                                  :public_current_missions, :public_finished_missions]
  before_action :set_user_with_session, only: [:current_missions, :finished_missions]
  before_action :pop_session_info_to_navbar, only: [:show, :edit, :index]
  before_action :touch_current_missions, only: [:current_missions, :finished_missions, 
                                                :public_current_missions, :public_finished_missions]

  # 各种操作（除了创建用户和返回JSON的前端回调以外）都需要用户登录
  before_filter :has_logined, except: [:new, :create,
                                       :current_missions, :finished_missions,
                                       :public_current_missions, :public_finished_missions]
  # 有些操作只允许对自己的页面进行
  before_filter :is_hoster, only: [:edit, :update, :destroy]
  before_filter :check_session_timeout, except: [:new, :create, 
                                                 :public_current_missions, :public_finished_missions]

  authorize_resource :only => [:current_missions, :finished_missions]

  layout 'user'

  # 设置每次分页的大小
  PAGE_SIZE = 8

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
    # 是访客而非页面的主人
    if session[:user_id] != params[:id].to_i
      @user.is_visitor = true
    else
      @user.is_visitor = false
      # 个人主页三大功能之一：创建新的任务
      @mission = Mission.new
      @mission.user_id = session[:user_id]
      @mission.user_token= session[:user_id]
    end

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

  # 获取所有未完成的Missions，更新它们并返回当前的Missions
  def current_missions
    @missions = @user.missions(true).where(finished: false).order('updated_at DESC')
    response_current_missions()
  end

  # 获取所有Missions，更新它们并返回已完成的Missions
  def finished_missions
    page = params[:page].to_i
    if page.nil? || page <= 0
      page = 1
    end

    # collectons.where的结果会被缓存下来
    @missions_num = @user.missions(true).where(finished: true).count
                          .fdiv(PAGE_SIZE).ceil
    if page <= @missions_num
      @missions = @user.missions.where(finished: true).order('updated_at DESC')
                      .limit(PAGE_SIZE).offset((page - 1) * PAGE_SIZE)
    else
      @missions = nil
    end

    response_finished_missions()
  end

  # 等同于同名无public前缀方法，不过只返回public=true的任务。不需要验证
  def public_current_missions
    @missions = @user.missions(true).where(public: true, finished: false).order('updated_at DESC')
    response_current_missions()
  end

  # 等同于同名无public前缀方法，不过只返回public=true的任务。不需要验证
  def public_finished_missions
    page = params[:page].to_i
    if page.nil? || page <= 0
      page = 1
    end

    @missions_num = @user.missions(true).where(public: true, finished: true).count
                          .fdiv(PAGE_SIZE).ceil
    if page <= @missions_num
      @missions = @user.missions.where(public: true, finished: true).order('updated_at DESC')
                    .limit(PAGE_SIZE).offset((page - 1) * PAGE_SIZE)
    else
      @missions = nil
    end

    response_finished_missions()
  end

  # 更新用户当前的任务，如果超时了，把它设为已完成且已失败
  def touch_current_missions
    @missions = @user.missions.where(finished: false)
    update_lost_missions(@missions)
  end

  private

    # 更新Missions数组中的所有Mission，更新缺勤天数，连续缺勤天数和是否失败
    # missions统一为AssociationRelation类型的数组
    def update_lost_missions(missions)
      return if missions.nil?
      if missions.length == 1
        update_lost_mission(missions.first)
      else
        missions.each do |mission|
          update_lost_mission(mission)
        end
      end

      
      @user.finished_missions += missions.count { |mission| mission.finished == true }
      @user.current_missions = missions.count { |mission| mission.finished == false }
      begin
        @user.save!
      rescue ActiveRecord::RecordInvalid
        logger.info "user save failed with #{@user} when update_lost_missions"
      end
    end

    # 跟cancancan配套使用，注意不需要重新构造用户对象。当前用户不存在则返回nil
    def current_user
        @user ||= nil
        @user.is_visitor = true if @user && @user.id != session[:user_id]
        @user
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user_with_params
      begin
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        return not_found()
      end
    end

    def set_user_with_session
      begin
        @user = User.find(session[:user_id])
      rescue ActiveRecord::RecordNotFound
        return not_found()
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :name, :sex, :year, :date, 
                                   :password, :password_confirmation, :email)
    end

    # 只有是页面主人才能提交修改
    def is_hoster
      if session[:user_id] != params[:id].to_i
        respond_to do |format|
          format.json { render json: {:msg => "unauthentication"}, 
                        status: :forbidden}
          format.html { redirect_to :status => :forbidden  }
        end
        return
      end
    end

    # update_lost_missions 对集合中的每个元素调用该方法来完成实际工作
    # mission为Mission对象
    def update_lost_mission(mission)
      if !mission.finished
        attributes = {}
        gap_days = (Date.yesterday - mission.last_clock_out.to_date).to_i

        if gap_days > 0
          attributes[:drop_out_days] = mission.drop_out_days + gap_days
          check_drop_out_limit(mission, attributes)

          attributes[:missed_days] = mission.missed_days + gap_days
          check_missed_limit(mission, attributes)

          begin
            mission.update!(attributes)
          rescue ActiveRecord::RecordInvalid => e
            logger.info "update mission failed when update_lost_mission"
            logger.info e
          end
        end
      end
    end

    def check_missed_limit(mission, attributes)
      if !attributes[:missed_days].nil? &&
          attributes[:missed_days] >= mission.missed_limit
        attributes[:missed_days] = mission.missed_limit
        attributes[:finished] = true
        attributes[:aborted] = true
      end
    end

    def check_drop_out_limit(mission, attributes)
      if !attributes[:drop_out_days].nil? && 
          attributes[:drop_out_days] >= mission.drop_out_limit
        attributes[:drop_out_days] = mission.drop_out_limit
        attributes[:finished] = true
        attributes[:aborted] = true
      end
    end

    # 包装所有*finished_missions方法的公有处理部分
    def response_finished_missions
      if !@missions || @missions.empty?
        # 如果用户尚未创建任何任务或没有已完成的任务，返回一个空的json对象
        respond_to { |format| format.json { render json: {} }}
      else
        respond_to do |format|
          format.json { render :finished_missions }
        end
      end
    end

    # 包装所有*current_missions方法的公有处理部分
    def response_current_missions
      if !@missions || @missions.empty?
        # 如果用户尚未创建任何任务或没有正在进行中的任务，返回一个空的json对象
        respond_to { |format| format.json { render json: {} }}
      else
        respond_to do |format|
          format.json { render :current_missions}
        end
      end
    end

end
