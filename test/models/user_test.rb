require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :users
  def new_user
    return User.new(:name => 'abc',
                   :email => 'a@163.com',
                   :year => 2000,
                   :date => '02-28',
                   :member_no => 4,
                   :join_date => '2013-07-18',
                   :last_actived => '2014-07-18',
                   :password_hash => 'aaxfaa')
  end

  test "name, email, password not blank" do
    user = new_user()
    user.name = ""
    assert_invalid(user, 'name')
    user.name = 'a'
    assert_valid(user)
    user.password = ""
    user.password_hash = ""
    assert_invalid(user, 'password')
    # then give a hash_password field
    user.password_hash = "ZSDAS"
    assert_valid(user)
  end

  test "email is valid" do
    user = new_user()
    user.email = 'a@123.21.com'
    assert_invalid(user, 'email')
    user.email = 'a@163.com.cn'
    assert_valid(user)
  end

  test "the length of name is not more than 30 " do
    user = new_user()
    user.name = "Iamverylonglonglonglonglonglong"
    assert_invalid(user, 'name')
  end

  test "the year is greater than 1990 and less than 2015" do
    user = new_user()
    user.year = 1887
    assert_invalid(user, 'year')
    user.year = 1991
    assert_valid(user)
    user.year = 2015
    assert_invalid(user, 'year')
  end

  test "date format valid" do
    user = new_user()
    user.date = '02-29'
    assert_invalid(user, 'date')
  end

  test "member_no is valid" do
    user = new_user()
    user.member_no = 1
    # member_no can not be the same with existed fixtures
    assert_invalid(user, 'member_no')
  end
end

