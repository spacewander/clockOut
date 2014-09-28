class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :update, :destroy, :clock_out, :abort]
  before_action :do_not_change_finished_mission, only: [:update, :clock_out, :abort]

  # 需要添加对于提交人的信息的验证，只有用户本人才能修改个人的任务
  before_filter :authenticate_for_user, only: [:create, :edit, :update, :destroy]

  authorize_resource :only => [:clock_out, :abort]

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # POST /missions
  # POST /missions.json
  def create
    @mission = Mission.new(mission_params)

    # 初始化当前进展记录
    @mission.finished_days = 0
    @mission.missed_days = 0
    @mission.drop_out_days = 0
    @mission.last_clock_out = Date.today

    @mission.public ||= false

    respond_to do |format|
      if @mission.user && @mission.save

        created_missions = @mission.user.created_missions + 1
        @mission.user.update(created_missions: created_missions)
        begin
          @mission.save!
        rescue ActiveRecord::RecordInvalid
          logger.info "mission save failed with #{@mission} when created "
        end

        format.html { redirect_to user_path(params['mission'][:user_id].to_i), 
                      notice: '任务已成功创建' }
        format.json { render :show, status: :created, location: @mission }
      else
        logger.debug "任务创建失败"
        logger.debug @mission.errors.full_messages
        format.html { redirect_to user_path(params['mission'][:user_id].to_i), 
                      notice: '任务创建失败'}
        format.json { render json: @mission.errors, status: 
                      :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /missions/1
  # PATCH/PUT /missions/1.json
  def update
    respond_to do |format|
      if @mission.update(mission_updateble_params)
        format.html { redirect_to user_path(params['mission'][:user_id].to_i), 
                      notice: '任务已成功更新' }
        format.json { render :current, status: :ok, location: @mission }
      else
        format.html { redirect_to user_path(params['mission'][:user_id].to_i), 
                      notice: '任务更新失败'}
        format.json { render json: @mission.errors, status: 
                      :unprocessable_entity }
      end
    end
  end

  # DELETE /missions/1
  # DELETE /missions/1.json
  def destroy
    #@mission.destroy
    #respond_to do |format|
      #format.html { redirect_to user_path(params['mission'][:user_id].to_i), 
                    #notice: '任务已成功删除' }
      #format.json { head :no_content }
    #end
  end

  # 每天打卡身心健康
  def clock_out
    @mission.finished_days += 1
    @mission.drop_out_days = 0
    @mission.last_clock_out = Date.today
    if @mission.finished_days >= @mission.days
      @mission.finished = true
    end

    save_and_return_current_mission
  end

  # 放弃某些任务
  def abort
    @mission.aborted = true
    @mission.finished = true

    save_and_return_current_mission
  end

  private

    def save_and_return_current_mission
      respond_to do |format|
        if @mission.save
          format.json { render :current, status: :ok }
        else
          format.json { render :invalid }
        end
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_mission
      begin
        @mission = Mission.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        @error_message = "找不到任务"
        return respond_to do |format|
          format.json { render 'application/err', status: 404 }
          format.html { redirect_to status: 404 }
        end
      end
    end

    def current_user
      if @mission
        @user = @mission.user
        unless @user.nil?
          if session[:last_seen] && ((Time.now - session[:last_seen]) / 1.days).round > 1
            reset_session
          end

          if @user.id == session[:user_id]
            @user.is_visitor = false
          else
            @user.is_visitor = true 
          end
        end
        @user
      else
        nil
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mission_params
      params_for_mission = {}
      [:name, :days, :missed_limit, :drop_out_limit, :content, :public, :user_id]
      .each {|item| params_for_mission[item] = params["mission"][item]}

      return params_for_mission
    end

    # 目前只允许更新任务内容
    def mission_updateble_params
      params.require(:user).permit(:content)
    end

    def authenticate_for_user
      user_id = params['mission'][:user_id].to_i
      user_token = params['mission'][:user_token]
      if !user_id || user_id.to_i <= 0
        forbidden()
      elsif !user_token || !(Mission.user_token_correct?(user_id, user_token))
        forbidden()
      end
    end

    def do_not_change_finished_mission
      if @mission && @mission.finished
        @error_message = '不能修改已完成的任务！'
        return respond_to do |format|
          format.json { render 'application/err' }
        end
      end
    end

end
