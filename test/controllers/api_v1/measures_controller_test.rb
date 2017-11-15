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
    measures_set = File.join("draft_measures", "base_set")
    collection_fixtures(measures_set, users_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    associate_user_with_patients(@user,Record.all)
    associate_measures_with_patients(Measure.all, Record.all)
    @num_patients = Record.all.size
    @measure = Measure.where({"cms_id" => "CMS128v2"}).first
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
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_type: 'eh', calculation_type: 'episode'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Missing parameter: measure_file" }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when measure_file is not a file" do
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: 'not-a-file.gif', measure_type: 'eh', calculation_type: 'episode'}, {format: 'multipart/form-data'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_file': Must be a valid MAT Export or HQMF File." }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when the measure zip is not a MAT Export" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','not_mat_export.zip'),'application/zip')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}, {"Content-Type" => 'multipart/form-data'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_file': Must be a valid MAT Export or HQMF File." }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when measure_file is not a .zip or .xml" do
    measure_file = fixture_file_upload(File.join('test','fixtures','draft_measures', 'base_set', 'CMS104v2.json'),'application/json')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}, {"Content-Type" => 'multipart/form-data'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_file': Must be a valid MAT Export or HQMF File." }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when measure_type is invalid" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'no', calculation_type: 'episode'}, {"Content-Type" => 'multipart/form-data'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_type': Must be one of: eh, ep." }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when calculation_type is invalid" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'ep', calculation_type: 'addition'}, {"Content-Type" => 'multipart/form-data'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Invalid parameter 'calculation_type': Must be one of: episode, patient." }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad_request when calculation_type is not provided" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'ep'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Missing parameter: calculation_type" }
    assert_equal expected_response, JSON.parse(response.body)
  end

  test "should create api_v1_measure initial" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :success
    expected_response = { "status" => "success", "url" => "/api_v1/measures/42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}
    assert_equal expected_response, JSON.parse(response.body)
    
    measure = Measure.where({hqmf_set_id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}).first

    assert_equal 29, measure.value_sets.count
    assert_equal @user.id, measure.user_id
    measure.value_sets.each {|vs| assert_equal @user.id, vs.user_id}
    assert_equal false, measure.needs_finalize
    assert_equal true, measure.episode_of_care?
    assert_equal 'eh', measure.type
    assert_nil measure.population_criteria['DENOM']['preconditions']
    assert_operator measure.map_fns[0].length, :>, 100
    assert_equal ["OccurrenceAInpatientEncounter1"], measure.episode_ids
    
  end
  
  test "should error on duplicate measure" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :success
    expected_response = { "status" => "success", "url" => "/api_v1/measures/42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}
    assert_equal expected_response, JSON.parse(response.body)
    
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :conflict
    expected_response = { "status" => "error", "messages" => "A measure with this HQMF Set ID already exists.", "url" => "/api_v1/measures/42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad request on episode of care measurement with no specific occurrence" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','no_ipp_Artifacts.zip'),'application/zip')
    
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Episode of care calculation was specified. Episode of care measures require at lease one data element that is a specific occurrence.  Please add a specific occurrence data element to the measure logic." }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return bad request on episode of care measurement with episode_of_care out of bounds" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', episode_of_care: 7}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "The episode_of_care index is out of bounds of the set of specific occurrences found in the mesasure." }
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should choose default titles for populations" do
    measure_file = fixture_file_upload(File.join('testplan','435ComplexV2_v4_Artifacts.zip'),'application/zip')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :ok
    expected_response = { "status" => "success", "url" => "/api_v1/measures/E29E44C3-ACD8-4E32-A68E-D89DBE3E7406"}
    assert_equal expected_response, JSON.parse(response.body)
    
    measure = Measure.where({hqmf_set_id: "E29E44C3-ACD8-4E32-A68E-D89DBE3E7406"}).first
    assert_equal 3, measure.populations.size
    assert_equal "Population 1", measure.populations[0]['title']
    assert_equal "Population 2", measure.populations[1]['title']
    assert_equal "Stratification 1", measure.populations[2]['title']
    
    assert_equal ["OccurrenceAInpatientEncounter1"], measure.episode_ids
  end
  
  test "should use provided population titles for populations" do
    measure_file = fixture_file_upload(File.join('testplan','435ComplexV2_v4_Artifacts.zip'),'application/zip')
    
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', population_titles: ['First Pop', 'Second Pop', 'Only Strat']}
    assert_response :ok
    expected_response = { "status" => "success", "url" => "/api_v1/measures/E29E44C3-ACD8-4E32-A68E-D89DBE3E7406"}
    assert_equal expected_response, JSON.parse(response.body)
    
    measure = Measure.where({hqmf_set_id: "E29E44C3-ACD8-4E32-A68E-D89DBE3E7406"}).first
    assert_equal 3, measure.populations.size
    assert_equal "First Pop", measure.populations[0]['title']
    assert_equal "Second Pop", measure.populations[1]['title']
    assert_equal "Only Strat", measure.populations[2]['title']
    
    assert_equal ["OccurrenceAInpatientEncounter1"], measure.episode_ids
  end
  
  test "should error on measure with missing value sets" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_no_vs.zip'),'application/zip')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "The measure value sets could not be found. Please re-package the measure in the MAT and make sure &quot;VSAC Value Sets&quot; are included in the package, then re-export the MAT Measure bundle."}
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should create measure from hqmf xml with vsac creds" do
    VCR.use_cassette("mat_api_435Complex") do
      measure_file = fixture_file_upload(File.join('testplan','435ComplexV2_v4_SimpleXML.xml'),'application/xml')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', population_titles: ['First Pop', 'Second Pop', 'Only Strat'], vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD']}
      assert_response :ok
      expected_response = { "status" => "success", "url" => "/api_v1/measures/E29E44C3-ACD8-4E32-A68E-D89DBE3E7406"}
      assert_equal expected_response, JSON.parse(response.body)
      
      measure = Measure.where({hqmf_set_id: "E29E44C3-ACD8-4E32-A68E-D89DBE3E7406"}).first
      assert_equal 3, measure.populations.size
      assert_equal "First Pop", measure.populations[0]['title']
      assert_equal "Second Pop", measure.populations[1]['title']
      assert_equal "Only Strat", measure.populations[2]['title']
      
      assert_equal ["OccurrenceAInpatientEncounter1"], measure.episode_ids
    end
  end
  
  test "should error on create measure from hqmf xml with bad vsac creds" do
    VCR.use_cassette("bad_vsac_creds") do
      measure_file = fixture_file_upload(File.join('testplan','435ComplexV2_v4_SimpleXML.xml'),'application/xml')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', population_titles: ['First Pop', 'Second Pop', 'Only Strat'], vsac_username: "sketchyguy", vsac_password: "goodpassword"}
      assert_response :internal_server_error
      expected_response = { "status" => "error", "messages" => "Error Loading Value Sets from VSAC: Error Loading Value Sets from VSAC: 401 Unauthorized"}
      assert_equal expected_response, JSON.parse(response.body)
    end
  end
  
  test "should error on create measure from hqmf xml without vsac creds" do
    measure_file = fixture_file_upload(File.join('testplan','435ComplexV2_v4_SimpleXML.xml'),'application/xml')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', population_titles: ['First Pop', 'Second Pop', 'Only Strat']}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Missing parameter: vsac_username"}
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should error on create measure from hqmf xml with include_draft false and bad vsac_date" do
    measure_file = fixture_file_upload(File.join('testplan','435ComplexV2_v4_SimpleXML.xml'),'application/xml')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', population_titles: ['First Pop', 'Second Pop', 'Only Strat'], vsac_username: 'test', vsac_password: 'badpass', include_draft: false, vsac_date: 'notadate'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Invalid parameter 'vsac_date': Must be a date in the form mm/dd/yyyy."}
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should error on create measure from hqmf xml with include_draft false and no vsac_date" do
    measure_file = fixture_file_upload(File.join('testplan','435ComplexV2_v4_SimpleXML.xml'),'application/xml')
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', population_titles: ['First Pop', 'Second Pop', 'Only Strat'], vsac_username: 'test', vsac_password: 'badpass', include_draft: false}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "Missing parameter: vsac_date"}
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should update api_v1_measure" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')

    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :success
    expected_response = { "status" => "success", "url" => "/api_v1/measures/42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}
    assert_equal expected_response, JSON.parse(response.body)
    
    measure = Measure.where({hqmf_set_id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}).first

    assert_equal 29, measure.value_sets.count
    assert_equal @user.id, measure.user_id
    measure.value_sets.each {|vs| assert_equal @user.id, vs.user_id}
    assert_equal false, measure.needs_finalize
    assert_equal true, measure.episode_of_care?
    assert_equal 'eh', measure.type
    assert_nil measure.population_criteria['DENOM']['preconditions']
    assert_operator measure.map_fns[0].length, :>, 100
    assert_equal ["OccurrenceAInpatientEncounter1"], measure.episode_ids
    
    assert_equal "FAKE_941657", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.93'}).first.concepts.first.code
    assert_equal "FAKE_977601", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.201'}).first.concepts.first.code
    assert_equal "FAKE_312269", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.233'}).first.concepts.first.code
    assert_equal "FAKE_312269", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.212'}).first.concepts.first.code
    assert_equal "FAKE_435307", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.247'}).first.concepts.first.code
    
    measure_update_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_update.zip'),'application/zip')

    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    put :update, {id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure_file: measure_update_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :success
    expected_response = { "status" => "success", "url" => "/api_v1/measures/42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}
    assert_equal expected_response, JSON.parse(response.body)
    
    measure = Measure.where({hqmf_id: '40280381-3D27-5493-013D-4DCA4B826XXX'}).first
    assert_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure.hqmf_set_id
    assert_equal 29, measure.value_sets.count
    assert_equal @user.id, measure.user_id
    measure.value_sets.each {|vs| assert_equal @user.id, vs.user_id}
    assert_equal false, measure.needs_finalize
    assert_equal true, measure.episode_of_care?
    assert_equal 'eh', measure.type
    assert_includes measure.episode_ids, 'OccurrenceAInpatientEncounter1'
    assert_equal 1, measure.episode_ids.length
    assert_operator measure.map_fns[0].length, :>, 100

    assert !measure.population_criteria['DENOM']['preconditions'].nil?
    assert_equal 1, measure.population_criteria['DENOM']['preconditions'].count

    assert_equal "UPDATED_435838", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.93'}).first.concepts.first.code
    assert_equal "UPDATED_144582", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.201'}).first.concepts.first.code
    assert_equal "UPDATED_802054", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.233'}).first.concepts.first.code
    assert_equal "UPDATED_802054", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.212'}).first.concepts.first.code
    assert_equal "UPDATED_224349", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.247'}).first.concepts.first.code
  end
  
  test "should return 404 on updating non existent measure" do
    measure_update_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_update.zip'),'application/zip')

    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    put :update, {id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure_file: measure_update_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :not_found
    expected_response = { "status" => "error", "messages" => "No measure found for this HQMF Set ID."}
    assert_equal expected_response, JSON.parse(response.body)
  end
  
  test "should return error on updating measure with incorrect hqmf_set_id" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')

    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :success
    expected_response = { "status" => "success", "url" => "/api_v1/measures/42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}
    assert_equal expected_response, JSON.parse(response.body)
    
    
    measure_update_file = fixture_file_upload(File.join('testplan','435ComplexV2_v4_Artifacts.zip'),'application/zip')
    
    @request.env["CONTENT_TYPE"] = "multipart/form-data"
    put :update, {id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure_file: measure_update_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :bad_request
    expected_response = { "status" => "error", "messages" => "You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure."}
    assert_equal expected_response, JSON.parse(response.body)
  end
end
