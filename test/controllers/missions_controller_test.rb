require 'test_helper'

class MissionsControllerTest < ActionController::TestCase
  setup do
    @mission = missions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:missions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mission" do
    assert_difference('Mission.count') do
      post :create, mission: { aborted: @mission.aborted, content: @mission.content, days: @mission.days, drop_out_days: @mission.drop_out_days, drop_out_limit: @mission.drop_out_limit, finished: @mission.finished, finished_days: @mission.finished_days, missed_days: @mission.missed_days, name: @mission.name, percents: @mission.percents, public: @mission.public, user_id: @mission.user_id }
    end

    assert_redirected_to mission_path(assigns(:mission))
  end

  test "should show mission" do
    get :show, id: @mission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mission
    assert_response :success
  end

  test "should update mission" do
    patch :update, id: @mission, mission: { aborted: @mission.aborted, content: @mission.content, days: @mission.days, drop_out_days: @mission.drop_out_days, drop_out_limit: @mission.drop_out_limit, finished: @mission.finished, finished_days: @mission.finished_days, missed_days: @mission.missed_days, name: @mission.name, percents: @mission.percents, public: @mission.public, user_id: @mission.user_id }
    assert_redirected_to mission_path(assigns(:mission))
  end

  test "should destroy mission" do
    assert_difference('Mission.count', -1) do
      delete :destroy, id: @mission
    end

    assert_redirected_to missions_path
  end
end
