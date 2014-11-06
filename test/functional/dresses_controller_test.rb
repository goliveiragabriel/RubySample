require 'test_helper'

class DressesControllerTest < ActionController::TestCase
  setup do
    @dress = dresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dress" do
    assert_difference('Dress.count') do
      post :create, dress: { brand: @dress.brand, description: @dress.description, featured: @dress.featured, name: @dress.name, share: @dress.share, vendor_id: @dress.vendor_id }
    end

    assert_redirected_to dress_path(assigns(:dress))
  end

  test "should show dress" do
    get :show, id: @dress
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dress
    assert_response :success
  end

  test "should update dress" do
    put :update, id: @dress, dress: { brand: @dress.brand, description: @dress.description, featured: @dress.featured, name: @dress.name, share: @dress.share, vendor_id: @dress.vendor_id }
    assert_redirected_to dress_path(assigns(:dress))
  end

  test "should destroy dress" do
    assert_difference('Dress.count', -1) do
      delete :destroy, id: @dress
    end

    assert_redirected_to dresses_path
  end
end
