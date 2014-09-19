ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # helper for unittest
  def assert_invalid object, item
    assert object.invalid?
    assert object.errors[item.to_sym].any?
  end

  def assert_valid object, item = ''
    object.valid?
    assert_equal(object.errors[item.to_sym], []) if item
  end

  # helper for functional test
  def json_reponse
    ActiveSupport::JSON.decode @response.body
  end

  # puts the message in assert_* method, for example:
  # assert_equal true, assigns(:user).is_visitor, puts_it("XX is not a visitor")
  def puts_it(msg)
    puts msg
  end

end
