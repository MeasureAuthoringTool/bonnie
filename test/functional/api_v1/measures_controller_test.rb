require 'test_helper'

class ApiV1::MeasuresControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  # StubToken simulates an OAuth2 token... we're not actually
  # verifying that a token was issued. This test completely
  # bypasses OAuth2 authentication and authorization provided
  # by Doorkeeper.
  class StubToken
    attr_accessor :resource_owner_id
    def acceptable?(value)
      true
    end
  end

  setup do
    @error_dir = File.join('log','load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    users_set = File.join("users", "base_set")
    measures_set = File.join("cql_measures", "CMS347v1")
    records_set = File.join("records", "CMS347v1")
    collection_fixtures(measures_set, users_set, records_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,CqlMeasure.all)
    associate_user_with_patients(@user,Record.all)
    associate_measures_with_patients(CqlMeasure.all, Record.all)
    @num_patients = Record.all.size
    @measure = CqlMeasure.where({"cms_id" => "CMS347v1"}).first
    @api_v1_measure = @measure.hqmf_set_id
    sign_in @user
    @token = StubToken.new
    @token.resource_owner_id = @user.id
    @controller.instance_variable_set('@_doorkeeper_token', @token)
  end

  test "should get index as html" do
    get :index
    assert_response :success
    assert_equal response.content_type, 'text/html'
    assert_not_nil assigns(:api_v1_measures)
  end

  test "should get index as json" do
    get :index, :format => "json"
    assert_response :success
    assert_equal response.content_type, 'application/json'
    json = JSON.parse(response.body)
    assert_equal 1, json.size
    assert_equal [], (json.map{|x|x['cms_id']} - ['CMS347v1'])
    assert_not_nil assigns(:api_v1_measures)
  end

  test "should show api_v1_measure" do
    get :show, id: @api_v1_measure
    assert_response :success
    assert_equal response.content_type, 'application/json'
    json = JSON.parse(response.body)
    assert_equal 'CMS347v1', json['cms_id']
    assert_not_nil assigns(:api_v1_measure)
  end

  test "should not show unknown measure" do
    get :show, id: 'foo'
    assert_response :missing
  end

  test "should show patients for api_v1_measure" do
    get :patients, id: @api_v1_measure
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @num_patients, json.size
    assert_equal ["With Fac", "With Fac No Start", "No Fac", "With Fac No End", "With Fac No Code", "With Fac No Time", "No Diagnosis or Fac"], json.map{|x|x["first"]}
  end

  test "should not show patients for unknown measure" do
    get :patients, id: 'foo'
    assert_response :missing
  end

  test "should get calculated_results as xlsx for api_v1_measure" do
    @request.env['HTTP_ACCEPT'] = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    get :calculated_results, id: @api_v1_measure

    assert_equal 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', response.content_type

    excel_file = File.open("#{Rails.root}/public/resource/Sample_Excel_Export(CMS52v6).xlsx", "rb")
    excel_binary = excel_file.read

    assert_equal response.body, excel_binary
    excel_file.close
  end
end
