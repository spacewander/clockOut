require 'test_helper'

class MissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :missions
  def new_mission
    return Mission.new(:name => 'write clockOut',
                      :days => 90,
                      :finished_days => 1,
                      :missed_days => 0,
                      :drop_out_days => 0,
                      :missed_limit => 20,
                      :drop_out_limit => 7,
                      :content => "好好学习，天天向上",
                      :finished => false,
                      :aborted => false,
                      :public => true,
                      :supervised => false)
  end
  
  test "name, day, limit cannot be empty" do
    mission = new_mission()
    mission.name = ''
    assert_invalid(mission, 'name')
    mission.name = 'test'
    mission.days = nil
    assert_invalid(mission, "days")
    mission.days = 90
    mission.missed_limit = nil
    assert_invalid(mission, 'missed_limit')
  end

  test "the number of days > 0 and < 10000" do
    mission = new_mission()
    mission.days = 0
    assert_invalid(mission, 'days')
    mission.days = 10000
    assert_invalid(mission, 'days')
  end

  test "number of limit >= 0 and < 10000" do
    mission = new_mission()
    mission.drop_out_limit = -1
    assert_invalid(mission, 'drop_out_limit')
    mission.drop_out_limit = 10000
    assert_invalid(mission, 'drop_out_limit')
    mission.drop_out_limit = 0
    assert_valid(mission)
  end

  test "all days and limits should be integer" do
    mission = new_mission()
    mission.days = 1.2
    assert_invalid(mission, 'days')
    mission.days = 90
    assert_valid(mission)
    mission.missed_limit = 12.1
    assert_invalid(mission, 'missed_limit')
  end

  test "special days cannot greater than total days" do
    mission = new_mission()
    mission.missed_days = 91
    assert_invalid(mission, 'missed_days')
  end

  test "limit cannot greater than total days" do
    mission = new_mission()
    mission.missed_limit = 91
    assert_invalid(mission, 'missed_limit')
  end

end
