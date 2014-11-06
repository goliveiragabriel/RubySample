require 'test_helper'

class QuotationsControllerTest < ActionController::TestCase
  setup do
    @quotation = quotations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quotations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quotation" do
    assert_difference('Quotation.count') do
      post :create, quotation: { comments: @quotation.comments, id: @quotation.id, number_guests: @quotation.number_guests, telephone: @quotation.telephone, user_id: @quotation.user_id, vendor_id: @quotation.vendor_id, wedding_date: @quotation.wedding_date }
    end

    assert_redirected_to quotation_path(assigns(:quotation))
  end

  test "should show quotation" do
    get :show, id: @quotation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quotation
    assert_response :success
  end

  test "should update quotation" do
    put :update, id: @quotation, quotation: { comments: @quotation.comments, id: @quotation.id, number_guests: @quotation.number_guests, telephone: @quotation.telephone, user_id: @quotation.user_id, vendor_id: @quotation.vendor_id, wedding_date: @quotation.wedding_date }
    assert_redirected_to quotation_path(assigns(:quotation))
  end

  test "should destroy quotation" do
    assert_difference('Quotation.count', -1) do
      delete :destroy, id: @quotation
    end

    assert_redirected_to quotations_path
  end
end
