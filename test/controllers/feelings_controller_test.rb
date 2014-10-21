require 'test_helper'

class FeelingsControllerTest < ActionController::TestCase
  setup do
    @input = {
      :content => '',
      :mission_id => 1
    }
    @user = users(:one)
  end

  # 基本的CRUD操作
  test "list all feeling relative to a mission" do
    get :index, :mission_id => 1, :format => 'json'
    assert_equal 2, json_reponse.length
  end

  test "return 404 if wrong mission id given" do
    get :index, :format => 'json', :mission_id => 0
    assert_response 404
  end

  test "create feeling" do
    session[:user_id] = 1
    assert_difference('Feeling.count') do
      post :create, :mission_id => 1, :feeling => @input, :format => 'json'
    end

    assert_equal 1, json_reponse['missionId']
  end

  test "create feeling should update day_name" do
    session[:user_id] = 1
    post :create, :mission_id => 1, :feeling => @input, :format => 'json'
    assert_equal '第11天', assigns(:feeling).day_name
  end

  test "should not use mission_id as input" do
    session[:user_id] = 1
    @input[:mission_id] = 2
    post :create, :mission_id => 1, :feeling => @input, :format => 'json'
    assert_equal 1, assigns(:feeling).mission_id
  end

  test "cannot create feeling when user is a visitor" do
    session[:user_id] = 2
    assert_no_difference('Feeling.count') do
      post :create, :mission_id => 1, :feeling => @input, :format => 'json'
    end
  end
   
  test "update feeling" do
    session[:user_id] = 1
    feeling = feelings(:two)
    feeling.content = ""
    put :update, :id => feelings(:two), :content => feeling[:content], 
      :mission_id => feelings(:two).mission_id, :format => 'json'
    assert_equal "", assigns(:feeling).content
  end

  test "only can update content" do
    session[:user_id] = 1
    feeling = feelings(:two)
    feeling.day_name = ""
    put :update, :id => feelings(:two), :content => feeling[:content], 
      :mission_id => feelings(:two).mission_id, :format => 'json'
    assert_not_equal "", assigns(:feeling).day_name
  end

  test "cannot update content when the user is a visitor" do
    session[:user_id] = 2
    feeling = feelings(:two)
    feeling.content = ""
    put :update, :id => feelings(:two), :content => feeling[:content],
      :mission_id => feelings(:two).mission_id, :format => 'json'
    assert_equal "测试是否只显示某个任务对应的感想", assigns(:feeling).content
  end

  # 测试cancan
  test "authorize create and update with cancancan" do
    @user.is_visitor = true
    ability = Ability.new(@user)
    assert ability.cannot?(:create, Feeling)
    assert ability.cannot?(:update, Feeling)

    @user.is_visitor = false
    ability = Ability.new(@user)
    assert ability.can?(:create, Feeling)
    assert ability.can?(:update, Feeling)
  end

end
