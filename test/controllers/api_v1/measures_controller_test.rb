require 'test_helper'

class ApiV1::MeasuresControllerTest < ActionController::TestCase
  include Devise::TestHelpers
      
  setup do
    @error_dir = File.join('log','load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    collection_fixtures("draft_measures", "records", "users")
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    associate_user_with_patients(@user,Record.all)
    associate_measures_with_patients(Measure.all, Record.all)
    @num_patients = Record.all.size
    @measure = Measure.where({"cms_id" => "CMS128v2"}).first
    @api_v1_measure = @measure.hqmf_set_id
    sign_in @user
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
    assert_equal 3, json.size
    assert_equal [], (json.map{|x|x['cms_id']} - ['CMS104v2','CMS128v2','CMS138v2'])
    assert_not_nil assigns(:api_v1_measures)
  end

  test "should show api_v1_measure" do
    get :show, id: @api_v1_measure
    assert_response :success
    assert_equal response.content_type, 'application/json'
    json = JSON.parse(response.body)
    assert_equal 'CMS128v2', json['cms_id']
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
    assert_equal [], (json.map{|x|x["last"]} - ['A','B','C','D'])
  end

  test "should not show patients for unknown measure" do
    get :patients, id: 'foo'
    assert_response :missing
  end

  test "should get calculated_results for api_v1_measure" do
    get :calculated_results, id: @api_v1_measure
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @num_patients, json['patient_count']
  end

  test "should not get calculated_results for unknown measure" do
    get :calculated_results, id: 'foo'
    assert_response :missing
  end

  test "should return bad_request when measure_file not provided" do
    post :create, {measure_type: 'eh', calculation_type: 'episode'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Missing parameter: measure_file" }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when measure_file is not a file" do
    post :create, {measure_file: 'not-a-file.gif', measure_type: 'eh', calculation_type: 'episode'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Invalid parameter: measure_file must be a file" }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when the measure zip is not a MAT Export" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','not_mat_export.zip'),'application/zip')
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "measure_file does not appear to be a MAT export." }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when measure_file is not a .zip or .xml" do
    measure_file = fixture_file_upload(File.join('test','fixtures','draft_measures','CMS104v2.json'),'application/json')
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Incorrect measure_file format." }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when measure_type is invalid" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    post :create, {measure_file: measure_file, measure_type: 'no', calculation_type: 'episode'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Invalid value: measure_type must be 'eh' or 'ep'." }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when calculation_type is invalid" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    post :create, {measure_file: measure_file, measure_type: 'ep', calculation_type: 'addition'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Invalid value: calculation_type must be 'patient' or 'episode'." }
    assert_equal expected_response, JSON.parse(response.body)
  end

  test "should create api_v1_measure initial" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')

    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :success
    expected_response = { "status" => "success", "url" => "/api_v1/measures/42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}
    assert_equal expected_response, JSON.parse(response.body)
    
    measure = Measure.where({hqmf_set_id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}).first

    assert_equal 29, measure.value_sets.count
  end
  
  test "should error on duplicate measure" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')

    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :success
    expected_response = { "status" => "success", "url" => "/api_v1/measures/42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}
    assert_equal expected_response, JSON.parse(response.body)
    
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :conflict
    
    measure = Measure.where({hqmf_set_id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}).first

    assert_equal 29, measure.value_sets.count
  end

  test "should update api_v1_measure" do
    skip
  end

end
