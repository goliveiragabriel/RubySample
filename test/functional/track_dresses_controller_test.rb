require 'test_helper'

class TrackDressesControllerTest < ActionController::TestCase
  setup do
    @track_dress = track_dresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:track_dresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create track_dress" do
    assert_difference('TrackDress.count') do
      post :create, track_dress: { dress_id: @track_dress.dress_id, user_id: @track_dress.user_id }
    end

    assert_redirected_to track_dress_path(assigns(:track_dress))
  end

  test "should show track_dress" do
    get :show, id: @track_dress
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @track_dress
    assert_response :success
  end

  test "should update track_dress" do
    put :update, id: @track_dress, track_dress: { dress_id: @track_dress.dress_id, user_id: @track_dress.user_id }
    assert_redirected_to track_dress_path(assigns(:track_dress))
  end

  test "should destroy track_dress" do
    assert_difference('TrackDress.count', -1) do
      delete :destroy, id: @track_dress
    end

    assert_redirected_to track_dresses_path
  end
end
