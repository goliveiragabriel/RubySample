require 'test_helper'

class AchievementsControllerTest < ActionController::TestCase
  setup do
    @achievement = achievements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:achievements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create achievement" do
    assert_difference('Achievement.count') do
      post :create, achievement: { action_type: @achievement.action_type, child_id: @achievement.child_id, message: @achievement.message, name: @achievement.name, score: @achievement.score, status: @achievement.status, user_merits_info_id: @achievement.user_merits_info_id }
    end

    assert_redirected_to achievement_path(assigns(:achievement))
  end

  test "should show achievement" do
    get :show, id: @achievement
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @achievement
    assert_response :success
  end

  test "should update achievement" do
    put :update, id: @achievement, achievement: { action_type: @achievement.action_type, child_id: @achievement.child_id, message: @achievement.message, name: @achievement.name, score: @achievement.score, status: @achievement.status, user_merits_info_id: @achievement.user_merits_info_id }
    assert_redirected_to achievement_path(assigns(:achievement))
  end

  test "should destroy achievement" do
    assert_difference('Achievement.count', -1) do
      delete :destroy, id: @achievement
    end

    assert_redirected_to achievements_path
  end
end
