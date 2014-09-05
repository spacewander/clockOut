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

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => @input
    end

    assert_redirected_to login_url
  end

  test "should update user" do
    session[:user_id] = @user.to_param
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
  
end
