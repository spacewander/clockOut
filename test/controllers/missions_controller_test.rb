require 'test_helper'
require 'digest/sha2'

class MissionsControllerTest < ActionController::TestCase
  setup do 
    @input = {
      :name => 'test',
      :days => 30,
      :missed_limit => 10,
      :drop_out_limit => 5,
      :content => "test test and more test",
      :user_id => 1,
      :user_token => Mission.encrypt_user_token(1)
    }

  @mission = missions(:one)
  @finished_mission = missions(:five)
  end 

  # 基本的crud操作
  test "should filter wrong mission id required" do
    get :show, :id => 0
    assert_response 404
  end

  test "should create mission" do
    assert_difference('Mission.count') do
      post :create, :mission => @input
    end

    assert_redirected_to user_path(@input[:user_id])
  end

  test "should strip mission.name and mission.content" do
    @input[:name] = "     strip it!  "
    @input[:content] = "  hate whitespace!  "
    post :create, :mission => @input
    assert_equal 'strip it!', assigns(:mission).name
    assert_equal 'hate whitespace!', assigns(:mission).content
  end

  test "should change user's created_missions and current_missions" do
    post :create, :mission => @input
    user = User.find(@input[:user_id])
    assert_equal 6, user.created_missions
    assert_equal 5, user.current_missions
  end

  test "should init some required attributes when create mission, 
    for instance, last_clock_out, finished_days, missed_days, drop_out_days" do
    post :create, :mission => @input

    assert_equal Date.today, assigns(:mission).last_clock_out
    assert_in_delta assigns(:mission).last_clock_out.to_date, 
      assigns(:mission).created_at.to_date, 1
    assert_equal 0, assigns(:mission).finished_days
    assert_equal 0, assigns(:mission).missed_days
    assert_equal 0, assigns(:mission).drop_out_days
  end

  test "could not create missions for non-existed user" do
    @input[:user_id] = 10
    post :create, :mission => @input
    assert_redirected_to login_path
  end

  test "should use user_id and authentication to authenticate user" do
    @input[:user_token] = ''
    post :create, :mission => @input
    assert_redirected_to login_url
    @input[:user_token] = 'test'
    post :create, :mission => @input
    assert_redirected_to login_url

    @input[:user_id] = 0
    post :create, :mission => @input
    assert_redirected_to login_url
  end

  # if user is a visitor
  test "should set is_visitor attribute when user.id is not the same with which 
        in session or there is not user_id in session" do
    get :clock_out, :id => @mission, :format => 'json' # trigger current_user private method
    assert_not_nil assigns(:user)
    assert_equal true, assigns(:user).is_visitor
  end

  # 注意这里把一个方面的测试分作三个来做，是因为cancancan调用current_user会使用缓存，
  # 导致一个测试内只会调用一次current_user
  test "set is_visitor attribute should work well(test 2)" do
    # @mission.id == 1
    session[:user_id] = 2
    get :clock_out, :id => @mission, :format => 'json'
    assert_not_nil assigns(:user)
    assert_equal true, assigns(:user).is_visitor
  end

  test "set is_visitor attribute should work well(test 3)" do
    session[:user_id] = 1
    get :clock_out, :id => @mission, :format => 'json'
    assert_not_nil assigns(:user)
    assert_equal false, assigns(:user).is_visitor
  end

  test "if session is timeout, user is treated as a visitor" do
    session[:user_id] = 1
    session[:last_seen] = 2.days.ago
    get :clock_out, :id => @mission, :format => 'json'
    assert_not_nil json_reponse['err']
    
    get :abort, :id => @mission, :format => 'json'
    assert_not_nil json_reponse['err']
  end

  test "if current user is vistor, he should not touch clock_out and abort" do
    get :clock_out, :id => @mission, :format => 'json'
    assert_not_nil json_reponse['err']
    
    get :abort, :id => @mission, :format => 'json'
    assert_not_nil json_reponse['err']
  end

  # abort, clock_out, and publish
  test "get clock_out should add finished_days and update mission" do
    session[:user_id] = @mission.user_id
    get :clock_out, :id => @mission, :format => 'json'

    assert_equal 0, json_reponse['dropOutDays']
    assert_equal 12, json_reponse['finishedDays']
  end

  test "get clock_out should update mission into finished state if need" do
    session[:user_id] = missions(:two).user_id
    get :clock_out, :id => missions(:two), :format => 'json'

    assert_equal true, json_reponse['finished']
  end

  test "一天只能打卡一次" do
    session[:user_id] = missions(:two).user_id
    get :clock_out, :id => missions(:two), :format => 'json'
    get :clock_out, :id => missions(:two), :format => 'json'

    assert_not_nil json_reponse['err']
  end

  test "should change user's finished_missions and current_missions if need" do
    session[:user_id] = missions(:nine).user_id
    get :clock_out, :id => missions(:nine), :format => 'json'
    user = User.find(1)
    assert_equal 5, user.created_missions
    assert_equal 3, user.current_missions
    assert_equal 2, user.finished_missions
    assert_equal true, assigns(:mission).finished
  end

  test "get abort should abort given mission" do
    session[:user_id] = @mission.user_id
    get :abort, :id => @mission, :format => 'json'

    assert_equal true, json_reponse['aborted']
    assert_equal true, json_reponse['finished']
  end

  test "should change user attrs after abort" do
    session[:user_id] = missions(:seven).user_id
    get :abort, :id => missions(:seven), :format => 'json'
    user = User.find(missions(:seven).user_id)
    assert_equal 1, user.created_missions
    assert_equal 0, user.current_missions
    assert_equal 1, user.finished_missions
  end

  test "publish public mission will make it private" do
    session[:user_id] = missions(:two).user_id
    get :publish, :id => missions(:two), :format => 'json'
    assert_equal false, assigns(:mission).public
  end

  test "publish private mission will make it public" do
    session[:user_id] = missions(:one).user_id
    get :publish, :id => missions(:one), :format => 'json'
    assert_equal true, assigns(:mission).public
  end

  test "abort, clock_out, publish and update only work at unfinished mission" do
    session[:user_id] = @finished_mission.user_id
    error_message = '不能修改已完成的任务！'

    put :update, :id => @finished_mission, :format => 'json'
    assert_equal error_message, json_reponse['err']
    get :abort, :id => @finished_mission, :format => 'json'
    assert_equal error_message, json_reponse['err']
    get :clock_out, :id => @finished_mission, :format => 'json'
    assert_equal error_message, json_reponse['err']
    get :publish, :id => @finished_mission, :format => 'json'
    assert_equal error_message, json_reponse['err']
  end

  test "authorize clock_out and abort, publish with cancancan" do
    @user = users(:one)
    @user.is_visitor = true
    ability = Ability.new(@user)
    assert ability.cannot?(:clock_out, Mission)
    assert ability.cannot?(:abort, Mission)
    assert ability.cannot?(:publish, Mission)

    @user.is_visitor = false
    ability = Ability.new(@user)
    assert ability.can?(:clock_out, Mission)
    assert ability.can?(:abort, Mission)
    assert ability.can?(:publish, Mission)
  end

  # 测试导航条
  test "导航条在abort任务之后更新" do
    session[:user_id] = @mission.user_id
    get :abort, :id => @mission, :format => 'json'
    assert_equal 3, assigns(:navbar).num
  end

  test "导航条在打卡之后更新" do
    session[:user_id] = missions(:two).user_id
    get :clock_out, :id => missions(:two), :format => 'json'
    assert_equal 3, assigns(:navbar).num
  end

  test "导航条在新增任务之后更新" do
    post :create, :mission => @input
    # 因为会发生重定向的缘故，所以不能测试navbar，就用session中的值作为代替
    assert_equal 5, session[:num] 
  end

end
