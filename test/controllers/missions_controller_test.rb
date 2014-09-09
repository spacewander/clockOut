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
      :user_id => 10,
      :user_token => Mission.encrypt_user_token(10)
    }

  @mission = missions(:one)
  end 

  test "should create mission" do
    assert_difference('Mission.count') do
      post :create, :mission => @input
    end

    assert_redirected_to user_path(@input[:user_id])
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

end
