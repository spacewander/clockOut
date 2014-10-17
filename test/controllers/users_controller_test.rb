require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do 
    @input = {
      :name => 'mickey',
      :password => 'mima',
      :password_confirmation => 'mima',
      :email => '123456@qq.com',
      :sex => ''
    }

  @user = users(:one)

  # 测试返回结果
  @finished_testcase = {"id"=>281110143, "name"=>"干点啥", "days"=>20, 
                       "missedLimit"=>3, "dropOutLimit"=>2, "aborted"=>true, 
                       "finishedDays"=>15, "missedDays"=>3, "dropOutDays"=>2, 
                       "public"=>true}
  @current_testcase = {"id"=>298486374, "name"=>"刷代码", "days"=>100, 
                       "missedLimit"=>20, "dropOutLimit"=>10, "finishedDays"=>99, 
                       "missedDays"=>4, "dropOutDays"=>1, "content"=>"就是刷代码", 
                       "aborted"=>false, "finished"=>false, "public"=>true, 
                       "supervised"=>true, "canClockOut"=>true}
  end 

  # 测试一般的http方法和用户访问权限的控制
  test "should use layouts/user as layout" do
    get :index
    assert_template layout: ["layouts/user", "user"]
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => @input
    end

    assert_redirected_to login_url
  end

  test "should update user" do
    session[:user_id] = @user.to_param.to_i
    put :update, :id => @user.to_param, :user => @input
    assert_redirected_to action: 'show', :id => @user.to_param
  end

  test "should clear the sessions of user who want to be forgot" do
    session[:user_id] = @user.to_param.to_i
    session[:last_seen] = 2.days.ago
    get :show, :id => @user.to_param
    assert_equal nil, session[:user_id]
    assert_equal nil, session[:last_seen]
    assert_redirected_to login_path
  end

  test "should protect from current_missions and finished_missions 
        for user who want to be forgot" do
    session[:user_id] = @user.to_param.to_i
    session[:last_seen] = 2.days.ago
    get :current_missions, :format => 'json'
    assert_redirected_to login_path
  end

  test "should protect from modify method in users_controller
        for user who want to be forgot" do
    session[:user_id] = @user.to_param.to_i
    session[:last_seen] = 2.days.ago
    put :update, :id => @user.to_param, :user => @input
    assert_redirected_to login_path
  end

  test "should ban for no-logined user" do
    get :index
    assert_redirected_to login_url
  end

  test "should ban for not hoster when try to edit the page" do
    session[:user_id] = @user.to_param.to_i - 1 # not hoster
    get :edit, :id => @user.to_param
    assert_response :forbidden
  end
  
  test "should redirect to 404 if can not set user(means user not found)" do
    get :show, :id => 'haha'
    assert_response 404
  end

  test "should set is_visitor attribute when visitor is not the hoster" do
    session[:user_id] = 1
    get :show, :id => 2
    assert_equal assigns(:user).is_visitor, true
  end

  test "should not show mission#new form when vistor is not the hoster" do
    session[:user_id] = 1
    get :show, :id => 2
    assert_template layout: "layouts/user"
    session[:user_id] = 2
    get :show, :id => 2
    assert_template layout: "layouts/user", partial: 'missions/_new_form'
  end

  # 测试是否会更新所有未完成的任务
  test "should touch current missions in finished_missions" do
    session[:user_id] = 1

    assert_difference('Mission.where(finished: false).count', -2) do
      get :finished_missions, :format => 'json'
    end
  end

  test "should touch current missions in current_missions" do
    session[:user_id] = 1

    assert_difference('Mission.where(finished: false).count', -2) do
      get :current_missions, :format => 'json'
    end
  end

  test "should touch current missions in public_current_missions" do
    session[:user_id] = 1

    assert_difference('Mission.where(finished: false).count', -2) do
      get :public_current_missions, :format => 'json', :id => 1
    end
  end

  test "should touch current missions in public_finished_missions" do
    session[:user_id] = 1

    assert_difference('Mission.where(finished: false).count', -2) do
      get :public_finished_missions, :format => 'json', :id => 1
    end
  end

  # 测试finished current 系列路由，包括返回值，对错误输入的过滤等等
  test "should update missions relative fields in User Table after touch finished missions" do
    session[:user_id] = 1
    get :finished_missions, :format => 'json'
    assert_equal 3, assigns(:user).finished_missions
    assert_equal 3, assigns(:user).current_missions
  end

  test "同一天多次访问finished_missions路由不会导致数据的不同" do
    session[:user_id] = 1
    get :finished_missions, :format => 'json'
    get :finished_missions, :format => 'json'
    assert_equal 3, assigns(:user).finished_missions
    assert_equal 3, assigns(:user).current_missions
  end

  test "should update missions relative fields in User Table after touch current missions" do
    session[:user_id] = 1
    get :finished_missions, :format => 'json'
    assert_equal 3, assigns(:user).finished_missions
    assert_equal 3, assigns(:user).current_missions
  end

  test "同一天多次访问current_missions路由不会导致数据的不同" do
    session[:user_id] = 1
    get :current_missions, :format => 'json'
    get :current_missions, :format => 'json'
    assert_equal 3, assigns(:user).finished_missions
    assert_equal 3, assigns(:user).current_missions
  end

  test "should redirect to 404 if current user doesn't exist" do
    session[:user_id] = nil
    get :finished_missions # trigger set_user_with_session private method
    assert_response 404
  end

  test "finished_missions should authorize with current_user" do
    get :finished_missions, :format => 'json' # get with current_user return nil
    assert_response 404
  end

  test "should return correct json when get the finished_missions" do
    session[:user_id] = 1
    get :finished_missions, :format => 'json'
    # 注意在jbuilder中把下划线式的命名转换成驼峰式了
    assert_equal 1, json_reponse['userId']
    # 过滤后的任务数
    assert_equal 3, json_reponse['finishedMissions'].length

    assert_equal true, 
      json_reponse['finishedMissions'].include?(@finished_testcase),
      json_reponse['finishedMissions']
    assert_equal true, 
      json_reponse['finishedMissions'][1]['missed_days'] == 
      json_reponse['finishedMissions'][1]['missed_limit']
  end

  test "should return {} when user doesn't create any mission" do
    session[:user_id] = 2
    get :finished_missions, :format => 'json'
    assert_equal true, json_reponse.empty?
  end
  
  test "should return {} when user doesn't have any finished mission" do
    session[:user_id] = 4
    get :finished_missions, :format => 'json'
    assert_equal true, json_reponse.empty?
  end

  test "current_missions should authorize with current_user" do
    get :current_missions, :format => 'json' # get with current_user return nil
    assert_response 404
  end

  test "should return correct json when get the current_missions" do
    session[:user_id] = 1
    get :current_missions, :format => 'json'
    # 注意在jbuilder中把下划线式的命名转换成驼峰式了
    assert_equal 1, json_reponse['userId']
    # 过滤后的任务数
    assert_equal 3, json_reponse['currentMissions'].length

    assert_equal true, 
      json_reponse['currentMissions'].include?(@current_testcase),
      json_reponse['currentMissions']
  end

  test "should return {} when user doesn't have any current mission" do
    session[:user_id] = 3
    get :current_missions, :format => 'json'
    assert_equal true, json_reponse.empty?
  end

  test "should return page num of finished_missions" do
    session[:user_id] = 1
    get :finished_missions, :format => 'json', :id => 1
    # PAGE_SIZE = 8, and finished_missions = 3
    assert_equal 1, json_reponse['pageNum']
  end

  # 测试public_* 系列路由，包括返回值，对错误输入的过滤等等
  test "public_* method should return {} when user doesn't have any public mission" do
    get :public_finished_missions, :id => 3, :format => "json"
    assert_equal true, json_reponse.empty?
    get :public_current_missions, :id => 3, :format => "json"
    assert_equal true, json_reponse.empty?
  end

  test "public_current_missions method should not return {} when user have 
        any public and current mission" do
    get :public_current_missions, :id => 4, :format => "json"
    assert_equal false, json_reponse.empty?
    assert_equal 1, json_reponse['currentMissions'].length
  end

  test "public_finished_missions method should not return {} when user have
        any public and finished mission" do
    get :public_finished_missions, :id => 5, :format => "json"
    assert_equal false, json_reponse.empty?
    assert_equal 1, json_reponse['finishedMissions'].length
  end

  test "should return correct json when get the public_current_missions" do
    get :public_current_missions, :format => 'json', :id => 1
    # 注意在jbuilder中把下划线式的命名转换成驼峰式了
    assert_equal 1, json_reponse['userId']
    # 过滤后的任务数
    assert_equal 2, json_reponse['currentMissions'].length

    assert_equal true, 
      json_reponse['currentMissions'].include?(@current_testcase),
      json_reponse['currentMissions']
  end

  test "should return correct json when get the public_finished_missions" do
    get :public_finished_missions, :format => 'json', :id => 1
    # 注意在jbuilder中把下划线式的命名转换成驼峰式了
    assert_equal 1, json_reponse['userId']
    # 过滤后的任务数
    assert_equal 3, json_reponse['finishedMissions'].length

    assert_equal true, 
      json_reponse['finishedMissions'].include?(@finished_testcase),
      json_reponse['finishedMissions']
  end

  test "should return page num of public_finished_missions" do
    get :public_finished_missions, :format => 'json', :id => 1
    # PAGE_SIZE = 8, and public finished_missions = 3
    assert_equal 1, json_reponse['pageNum']
  end

  # 测试cancan
  test "authorize current_missions and finished_missions with cancancan" do
    @user.is_visitor = true
    ability = Ability.new(@user)
    assert ability.cannot?(:current_missions, User)
    assert ability.cannot?(:finished_missions, User)

    @user.is_visitor = false
    ability = Ability.new(@user)
    assert ability.can?(:current_missions, User)
    assert ability.can?(:finished_missions, User)
  end

  # 测试分页功能
  test "paginate with finished_missions: a too large page number given" do
    session[:user_id] = 1
    get :finished_missions, :format => 'json', :id => 1, :page => 100
    assert_equal true, json_reponse.empty?
  end

  test "paginate with public_finished_missions: a too large page number given" do
    get :public_finished_missions, :format => 'json', :id => 1, :page => 100
    assert_equal true, json_reponse.empty?
  end

  test "paginate with finished_missions: error page param given" do
    session[:user_id] = 1
    get :finished_missions, :format => 'json', :id => 1, :page => 'haha'
    assert_equal 1, json_reponse['userId']
    # 过滤后的任务数
    assert_equal 3, json_reponse['finishedMissions'].length
  end

  test "paginate with public_finished_missions: error page param given" do
    get :public_finished_missions, :format => 'json', :id => 1, :page => 'haha'
    assert_equal 1, json_reponse['userId']
    # 过滤后的任务数
    assert_equal 3, json_reponse['finishedMissions'].length

    assert_equal true, 
      json_reponse['finishedMissions'].include?(@finished_testcase),
      json_reponse['finishedMissions']
  end

  # 测试获取Mission资源时，用户id有错的情况
  test "if the user id is wrong when get Mission resource" do
    get :public_finished_missions, :format => 'json', :id => 'haha'
    assert_response 404
    get :public_current_missions, :format => 'json', :id => 'haha'
    assert_response 404

    session[:user_id] = 100
    get :finished_missions, :format => 'json', :id => 100
    assert_response 404
    get :current_missions, :format => 'json', :id => 100
    assert_response 404
  end

  test "if the user not found with given id when get Mission resource" do
    get :public_finished_missions, :format => 'json', :id => 'haha'
    assert_response 404
    get :public_current_missions, :format => 'json', :id => 'haha'
    assert_response 404

    session[:user_id] = 100
    get :finished_missions, :format => 'json', :id => 100
    assert_response 404
    get :current_missions, :format => 'json', :id => 100
    assert_response 404
  end

  # 测试对导航条的展示和更新
  test "导航条展示内容正确" do
    session[:user_id] = 1
    get :show, :id => 1
    assert_equal 4, assigns(:navbar).num
    assert_equal users(:one).name, assigns(:navbar).name
  end

  test "导航条在当前任务数改变后能及时更新" do
    session[:user_id] = 1
    get :current_missions, :format => 'json'
    assert_equal 3, assigns(:navbar).num
  end

end
