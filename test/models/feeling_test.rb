require 'test_helper'

class FeelingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def new_feeling
    return Feeling.new(:mission_id => 1,
                       :content => '',
                       :day_name => '第7天')
  end

  test "mission_id must be presenced and is an integer greater than 0" do
    feeling = new_feeling()
    feeling.mission_id = nil
    assert_invalid(feeling, 'mission_id')
    feeling.mission_id = 0
    assert_invalid(feeling, 'mission_id')
    feeling.mission_id = 1
    assert_valid(feeling)
  end

end
