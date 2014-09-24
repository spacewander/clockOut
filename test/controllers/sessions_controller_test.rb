require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should welcome to home when meet host" do
    user_id = 4
    session[:user_id] = user_id
    get :new
    assert_response :success
  end

  test "should login" do
    user = users(:session)
    post :create, :name => user.name, :password => 'mima'
    assert_equal user.id, session[:user_id]
    assert_redirected_to user_path(user.id)
  end

  test "should get destroy" do
    delete :destroy
    assert_equal nil, session[:user_id]
    assert_redirected_to login_url
  end

  test "should check session timeout in /index page" do
    session[:user_id] = 1
    session[:last_seen] = 2.days.ago
    get :index
    assert_equal nil, session[:user_id]
    assert_redirected_to login_path
  end

  test "should redirect_to user_path in /index page when session[:user_id] given" do
    session[:user_id] = 1
    get :index
    assert_redirected_to user_path(1)
  end

  test "should redirect_to login_path in /index page without session[:user_id] given" do
    get :index
    assert_redirected_to login_path
  end

end
