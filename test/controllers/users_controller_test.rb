require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do 
    @input = {
      :name => 'mickey',
      :password => 'mima',
      :password => 'mima',
      :email => '123456@qq.com',
      :sex => 'male'
    }

  @user = users(:one)
  end 

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => @input
    end

    member_no = User.find_by_name(@input[:name]).member_no
    assert_redirected_to action: 'show', :id => member_no
  end

  test "should update user" do
    put :update, :id => @user.to_param, :user => @input
    assert_redirected_to action: 'show', :id => @user.to_param
  end
  
end
