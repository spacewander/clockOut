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

  @finished_testcase = {"id"=>281110143, "name"=>"干点啥", "days"=>20, 
                       "missedLimit"=>3, "dropOutLimit"=>2, "aborted"=>true, 
                       "finishedDays"=>15, "missedDays"=>3, "dropOutDays"=>2, "public"=>true}
  @current_testcase = {"id"=>298486374, "name"=>"刷代码", "days"=>100, 
                       "missedLimit"=>20, "dropOutLimit"=>10, "finishedDays"=>10, 
                       "missedDays"=>4, "dropOutDays"=>1, "content"=>"就是刷代码", 
                       "public"=>true, "supervised"=>true}
  end 

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

  test "should set is_visitor attribution when visitor is not the hoster" do
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

  test "should redirect to 404 if current user doesn't exist" do
    session[:user_id] = nil
    get :finished_missions # trigger curent_user private method
    assert_response 404
  end

  test "should return correct json when get the finished_missions" do
    session[:user_id] = 1
    get :finished_missions, :format => 'json'
    # 注意在jbuilder中把下划线式的命名转换成驼峰式了
    assert_equal 1, json_reponse['userId']
    # 过滤后的任务数
    assert_equal 3, json_reponse['finishedMissions'].length

    assert_equal true, json_reponse['finishedMissions'].include?(@finished_testcase)
    assert_equal true, 
      json_reponse['finishedMissions'][1]['missed_days'] == json_reponse['finishedMissions'][1]['missed_limit']
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

  test "should return correct json when get the current_missions" do
    session[:user_id] = 1
    get :current_missions, :format => 'json'
    # 注意在jbuilder中把下划线式的命名转换成驼峰式了
    assert_equal 1, json_reponse['userId']
    # 过滤后的任务数
    assert_equal 2, json_reponse['currentMissions'].length

    assert_equal true, json_reponse['currentMissions'].include?(@current_testcase)
  end

  test "should return {} when user doesn't have any current mission" do
    session[:user_id] = 3
    get :current_missions, :format => 'json'
    assert_equal true, json_reponse.empty?
  end

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

  test "should return correct json when get the pulbic_current_missions" do
    get :public_current_missions, :format => 'json', :id => 1
    # 注意在jbuilder中把下划线式的命名转换成驼峰式了
    assert_equal 1, json_reponse['userId']
    # 过滤后的任务数
    assert_equal 1, json_reponse['currentMissions'].length

    assert_equal true, json_reponse['currentMissions'].include?(@current_testcase)
  end

  test "should return correct json when get the public_finished_missions" do
    get :public_finished_missions, :format => 'json', :id => 1
    # 注意在jbuilder中把下划线式的命名转换成驼峰式了
    assert_equal 1, json_reponse['userId']
    # 过滤后的任务数
    assert_equal 3, json_reponse['finishedMissions'].length

    assert_equal true, json_reponse['finishedMissions'].include?(@finished_testcase)
  end

end
