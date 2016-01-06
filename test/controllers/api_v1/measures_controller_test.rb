require 'test_helper'

class ApiV1::MeasuresControllerTest < ActionController::TestCase
  setup do
    @api_v1_measure = api_v1_measures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_v1_measures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_v1_measure" do
    assert_difference('ApiV1::Measure.count') do
      post :create, api_v1_measure: {  }
    end

    assert_redirected_to api_v1_measure_path(assigns(:api_v1_measure))
  end

  test "should show api_v1_measure" do
    get :show, id: @api_v1_measure
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_v1_measure
    assert_response :success
  end

  test "should update api_v1_measure" do
    patch :update, id: @api_v1_measure, api_v1_measure: {  }
    assert_redirected_to api_v1_measure_path(assigns(:api_v1_measure))
  end

  test "should destroy api_v1_measure" do
    assert_difference('ApiV1::Measure.count', -1) do
      delete :destroy, id: @api_v1_measure
    end

    assert_redirected_to api_v1_measures_path
  end
end
