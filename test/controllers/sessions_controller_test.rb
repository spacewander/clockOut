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

end
