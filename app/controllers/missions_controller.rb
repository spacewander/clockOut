class MissionsController < ApplicationController
  before_action :set_mission, only: [:show, :edit, :update, :destroy]

  # 需要添加对于提交人的信息的验证，只有用户本人才能修改个人的任务
  before_filter :authenticate_for_user, only: [:create, :edit, :update, :destroy]

  # POST /missions
  # POST /missions.json
  def create
    @mission = Mission.new(mission_params)

    # 初始化当前进展记录
    @mission.finished_days = 0
    @mission.missed_days = 0
    @mission.drop_out_days = 0

    @mission.public ||= false

    respond_to do |format|
      if @mission.save
        format.html { redirect_to user_path(params['mission'][:user_id].to_i), 
                      notice: '任务已成功创建' }
        format.json { render :show, status: :created, location: @mission }
      else
        #p @mission.errors.full_messages
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
      if @mission.update(mission_params)
        format.html { redirect_to user_path(params['mission'][:user_id].to_i), 
                      notice: '任务已成功更新' }
        format.json { render :show, status: :ok, location: @mission }
      else
        format.html { redirect_to user_path(params['mission'][:user_id].to_i), 
                      notice: '任务创建失败'}
        format.json { render json: @mission.errors, status: 
                      :unprocessable_entity }
      end
    end
  end

  # DELETE /missions/1
  # DELETE /missions/1.json
  def destroy
    @mission.destroy
    respond_to do |format|
      format.html { redirect_to user_path(params['mission'][:user_id].to_i), 
                    notice: '任务已成功删除' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mission
      @mission = Mission.find(params[:id])
    end

    def current_user
      if @mission
        @user = @mission.user
        @user.is_visitor = true if !@user.nil? && @user.id != session[:user_id]
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

    def authenticate_for_user
      user_id = params['mission'][:user_id].to_i
      user_token = params['mission'][:user_token]
      if !user_id || user_id.to_i <= 0
        forbidden()
      elsif !user_token || !(Mission.user_token_correct?(user_id, user_token))
        forbidden()
      end
    end

end
