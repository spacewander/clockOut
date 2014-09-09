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

end
