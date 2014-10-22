class FeelingsController < ApplicationController

  before_action :set_feeling, only: [:update]
  before_action :set_mission, only: [:index, :create, :update]

  authorize_resource :only => [:create, :update]

  def index
    @feelings = @mission.feelings.order('created_at')

    respond_to do |format|
      format.json
    end
  end

  def create
    @feeling = Feeling.new(feeling_params)
    @feeling.mission_id = params[:mission_id]
    @feeling.day_name = "第#{@mission.finished_days}天"

    respond_to do |format|
      if @feeling.save
        format.json { render :show, status: :created }
      else
        format.json { render json: @feeling.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if (Time.now - @feeling.created_at) > 1.day
      return respond_to do |format|
        format.json { render json: '{ "err": "不能更新当天之前的感想"}' }
      end
    end

    respond_to do |format|
      if @feeling.update(feeling_updateble_params)
        format.json { render :show, status: :ok }
      else
        format.json { render json: @feeling.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_feeling
    begin
      @feeling = Feeling.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      return not_found
    end
  end

  def set_mission
    begin
      @mission = Mission.find(params[:mission_id])
    rescue ActiveRecord::RecordNotFound
      return not_found
    end
  end

  def current_user
    set_mission unless @mission
    
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
  end

  def feeling_params
    params.permit(:id, :content)
  end

  def feeling_updateble_params
    params.permit(:content)
  end

end
