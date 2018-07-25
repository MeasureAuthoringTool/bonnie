require 'test_helper'

module ApiV1
  class MeasuresControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup do
      @error_dir = File.join('log','load_errors')
      FileUtils.rm_r @error_dir if File.directory?(@error_dir)
      dump_database
      users_set = File.join("users", "base_set")
      cms347_fixtures = File.join("cql_measures", "CMS347v1"), File.join("records", "CMS347v1")
      collection_fixtures(users_set, *cms347_fixtures)
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
      @ticket_expires_at = (Time.now + 8.hours).to_i
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
      assert_equal [], (json.map { |x| x['cms_id'] } - ['CMS347v1'])
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
      assert_equal ["No Diagnosis or Fac", "No Fac", "With Fac", "With Fac No Code", "With Fac No End", "With Fac No Start", "With Fac No Time"],
                  json.map { |x| x["first"] }.sort
    end

    test "should not show patients for unknown measure" do
      get :patients, id: 'foo'
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
      post :create, {measure_file: 'not-a-file.gif', measure_type: 'eh', calculation_type: 'episode', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}, {format: 'multipart/form-data'}
      assert_response :bad_request
      expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_file': Must be a valid MAT Export." }
      assert_equal expected_response, JSON.parse(response.body)
    end

    test "should return bad_request when measure_file is not a zip" do
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      not_zip_file = fixture_file_upload(File.join('test','fixtures','cql_measure_packages','CMS160v6','CMS160v6.json'))
      post :create, {measure_file: not_zip_file, measure_type: 'eh', calculation_type: 'episode', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}, {format: 'multipart/form-data'}
      assert_response :bad_request
      expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_file': Must be a valid MAT Export." }
      assert_equal expected_response, JSON.parse(response.body)
    end

    test "should return bad_request when the measure zip is not a MAT Export" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','special_measures','not_mat_export.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}, {"Content-Type" => 'multipart/form-data'}
      assert_response :bad_request
      expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_file': Must be a valid MAT Export." }
      assert_equal expected_response, JSON.parse(response.body)
    end

    test "should return bad_request when measure_type is invalid" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','CMS52_v5_4_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      post :create, {measure_file: measure_file, measure_type: 'no', calculation_type: 'episode', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}, {"Content-Type" => 'multipart/form-data'}
      assert_response :bad_request
      expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_type': Must be one of: <code>eh</code>, <code>ep</code>." }
      assert_equal expected_response, JSON.parse(response.body)
    end

    test "should return bad_request when calculation_type is invalid" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','CMS52_v5_4_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      post :create, {measure_file: measure_file, measure_type: 'ep', calculation_type: 'addition', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}, {"Content-Type" => 'multipart/form-data'}
      assert_response :bad_request
      expected_response = { "status" => "error", "messages" => "Invalid parameter 'calculation_type': Must be one of: <code>episode</code>, <code>patient</code>." }
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
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"

      measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
      assert_nil measure

      VCR.use_cassette("api_valid_vsac_response") do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'}, {"Content-Type" => 'multipart/form-data'}
        assert_response :success
        expected_response = { "status" => "success", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
        assert_equal expected_response, JSON.parse(response.body)
      end

      measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
      assert_equal "40280582-5859-673B-0158-DAEF8B750647", measure['hqmf_id']
      assert_equal @user.id, measure.user_id
      measure.value_sets.each { |vs| assert_equal @user.id, vs.user_id }
      assert_equal false, measure.episode_of_care?
      assert_equal 'ep', measure.type
    end

    test "should error on duplicate measure" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_valid_vsac_response") do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'}, {"Content-Type" => 'multipart/form-data'}
        assert_response :success
        expected_response = { "status" => "success", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
        assert_equal expected_response, JSON.parse(response.body)
      end

      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_valid_vsac_response") do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'}, {"Content-Type" => 'multipart/form-data'}
        assert_response :conflict
        expected_response = { "status" => "error", "messages" => "A measure with this HQMF Set ID already exists.", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test "should choose default titles for populations" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_valid_vsac_response") do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: "true", vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'}, {"Content-Type" => 'multipart/form-data'}
        assert_response :ok
        expected_response = { "status" => "success", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
        assert_equal expected_response, JSON.parse(response.body)

        measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
        assert_equal 6, measure.populations.size

        assert_equal "Population Criteria Section", measure.populations[0]['title']
        assert_equal "Population Criteria Section", measure.populations[1]['title']
        assert_equal "Stratification 1", measure.populations[2]['title']
      end
    end

    test "should use provided population titles for populations" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_valid_vsac_response") do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: "true", vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'ep', calculation_type: 'episode', population_titles: ['First Pop', 'Second Pop', 'Only Strat']}, {"Content-Type" => 'multipart/form-data'}
        assert_response :ok
        expected_response = { "status" => "success", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
        assert_equal expected_response, JSON.parse(response.body)

        measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
        assert_equal 6, measure.populations.size
        assert_equal "First Pop", measure.populations[0]['title']
        assert_equal "Second Pop", measure.populations[1]['title']
        assert_equal "Only Strat", measure.populations[2]['title']
      end
    end

    test "should update a measure with provided population titles for populations" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_valid_vsac_response") do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: "true", vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'ep', calculation_type: 'episode', population_titles: ['First Pop', 'Second Pop', 'Only Strat']}, {"Content-Type" => 'multipart/form-data'}
        assert_response :ok
        expected_response = { "status" => "success", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
        assert_equal expected_response, JSON.parse(response.body)
      end
      measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
      assert_equal 6, measure.populations.size
      assert_equal "First Pop", measure.populations[0]['title']
      assert_equal "Second Pop", measure.populations[1]['title']
      assert_equal "Only Strat", measure.populations[2]['title']

      # Associate patients with measure
      associate_measures_with_patients(CqlMeasure.all, Record.all)

      # Update the same measure
      VCR.use_cassette("api_valid_vsac_response") do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        put :update, {id: "762B1B52-40BF-4596-B34F-4963188E7FF7", vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: "true", vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'ep', calculation_type: 'episode', population_titles: %w[Foo bar baz]}, {"Content-Type" => 'multipart/form-data'}
        assert_response :ok
        expected_response = { "status" => "success", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
        assert_equal expected_response, JSON.parse(response.body)
      end
      measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
      assert_equal 6, measure.populations.size
      assert_equal "First Pop", measure.populations[0]['title']
      assert_equal "Second Pop", measure.populations[1]['title']
      assert_equal "Only Strat", measure.populations[2]['title']
    end

    test "should error on upload due to incorrect VSAC release parameter input" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_missing_vs_oid_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_invalid_release_vsac_response") do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {vsac_query_type: 'release', vsac_query_release: 'Fake 1234', vsac_query_measure_defined: "true", vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}, {"Content-Type" => 'multipart/form-data'}
        assert_response :bad_request
        expected_response = { "status" => "error", "messages" => "Error Loading VSAC Value Sets. VSAC value set (2.16.840.1.113883.3.526.3.1496) not found or is empty. Please verify that you are using the correct profile or release and have VSAC authoring permissions if you are requesting draft value sets."}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test "should error on upload due to invalid VSAC ticket" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_missing_vs_oid_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_invalid_ticket_vsac_response") do
        ticket = "foo"
        post :create, {vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}, {"Content-Type" => 'multipart/form-data'}
        assert_response :bad_request
        expected_response = { "status" => "error", "messages" => "Error Loading VSAC Value Sets. VSAC session expired. Please re-enter VSAC username and password to try again."}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test "should error on measure with missing value sets" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_missing_vs_oid_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_missing_vs_vsac_response") do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: "true", vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}, {"Content-Type" => 'multipart/form-data'}
        assert_response :bad_request
        expected_response = { "status" => "error", "messages" => "The measure is missing value sets. The following value sets are missing: [2.16.840.1.113883.3.464.1003.106.12.1005]"}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test "should return 404 on updating non existent measure" do
      measure_update_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_valid_vsac_response") do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        put :update, {id: "762B1B52-40BF-4596-B34F-4963188E7FF7", vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: "true", vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_update_file, measure_type: 'eh', calculation_type: 'episode'}, {"Content-Type" => 'multipart/form-data'}
        assert_response :not_found
        expected_response = { "status" => "error", "messages" => "No measure found for this HQMF Set ID."}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test "should return error on updating measure with incorrect hqmf_set_id" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_incorrect_hqmf_vsac_response") do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]

        post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at}, {"Content-Type" => 'multipart/form-data'}
        assert_response :success
        expected_response = { "status" => "success", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
        assert_equal expected_response, JSON.parse(response.body)

        measure_update_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_Artifacts_HQMF_SetId_Mismatch.zip'),'application/zip')
        put :update, {id: "762B1B52-40BF-4596-B34F-4963188E7FF7", measure_file: measure_update_file, measure_type: 'eh', calculation_type: 'episode', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at}, {"Content-Type" => 'multipart/form-data'}
        assert_response :not_found
        expected_response = { "status" => "error", "messages" => "The update file does not have a matching HQMF Set ID to the measure trying to update with. Please update the correct measure or upload the file as a new measure."}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test "should error on uploading measure with bad HQMF file" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_bad_hqmf_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_incorrect_hqmf_vsac_response") do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at}, {"Content-Type" => 'multipart/form-data'}
        assert_response :bad_request
        expected_response = {"status"=>"error", "messages"=>"The measure could not be loaded, Bonnie has encountered an error while trying to load the measure."}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test "should calculate supplemental data elements" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports', 'CCDELookback_v5_4_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_ccdelookback_vsac_response") do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {vsac_query_measure_defined: "false", vsac_query_include_draft: "false", vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', calculate_sdes: 'true'}, {"Content-Type" => 'multipart/form-data'}
        assert_response :success
        measure = CqlMeasure.where({hqmf_set_id: "FA75DE85-A934-45D7-A2F7-C700A756078B"}).first
        assert_equal true, measure.calculate_sdes
      end
    end

    test "should not calculate supplemental data elements" do
      measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports', 'CCDELookback_v5_4_Artifacts.zip'),'application/zip')
      @request.env["CONTENT_TYPE"] = "multipart/form-data"
      VCR.use_cassette("api_release_ccdelookback_vsac_response") do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, {vsac_query_type: 'release', vsac_query_measure_defined: "true", vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', calculate_sdes: 'false'}, {"Content-Type" => 'multipart/form-data'}
        assert_response :success
        measure = CqlMeasure.where({hqmf_set_id: "FA75DE85-A934-45D7-A2F7-C700A756078B"}).first
        assert_equal false, measure.calculate_sdes
      end
    end
  end
end