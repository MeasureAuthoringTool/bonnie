require 'test_helper'

module ApiV1
  class MeasuresControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup do
      @error_dir = File.join('log','load_errors')
      FileUtils.rm_r @error_dir if File.directory?(@error_dir)
      dump_database
      users_set = File.join('users', 'base_set')
      collection_fixtures(users_set)
      @user = User.by_email('bonnie@example.com').first
      sign_in @user
      @token = StubToken.new
      @token.resource_owner_id = @user.id
      @controller.instance_variable_set('@_doorkeeper_token', @token)
      @ticket_expires_at = (Time.now.utc + 8.hours).to_i

      @vcr_options = {match_requests_on: [:method, :uri_no_st]}

      @test_set_id = '39F9371B-8750-48D1-942D-7CBA70F415F7'
      @test_file = File.join('test', 'fixtures', 'fhir_measures', 'UnitTest_v6_0_Artifacts.zip')
    end

    test 'should get index as html' do
      load_measure_fixtures_from_folder(File.join('measures', 'CMS134v6'), @user)

      get :index
      assert_response :success
      assert_equal response.content_type, 'text/html'
      assert_not_nil assigns(:api_v1_measures)
    end

    test 'should get index as json' do
      load_measure_fixtures_from_folder(File.join('measures', 'CMS134v6'), @user)

      get :index, as: :json
      assert_response :success
      assert_equal response.content_type, 'application/json'
      json = JSON.parse(response.body)
      assert_equal 1, json.size
      assert_equal [], (json.map { |x| x['cms_id'] } - ['CMS134v6'])
      assert_not_nil assigns(:api_v1_measures)
    end

    test 'should show api_v1_measure' do
      skip("UPDATE FOR NEW MODEL")
      measure_file = fixture_file_upload(@test_file, 'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'

      measure = CQM::Measure.where({set_id: @test_set_id}).first
      assert_nil measure

      VCR.use_cassette('api_valid_vsac_response', @vcr_options) do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, calculation_type: 'patient'}
        assert_response :success
        expected_response = { 'status' => 'success', 'url' => "/api_v1/measures/#{@test_set_id}"}
        assert_equal expected_response, JSON.parse(response.body)
      end

      get :show, params: {id: @test_set_id}
      assert_response :success
      assert_equal response.content_type, 'application/json'
      json = JSON.parse(response.body)
      assert_equal 'v0', json['cms_id']
      assert_not_nil assigns(:api_v1_measure)
    end

    test 'should not show unknown measure' do
      load_measure_fixtures_from_folder(File.join('measures', 'CMS134v6'), @user)

      get :show, params: {id: 'foo'}
      assert_response :missing
    end

    # /measures/:id/patients is disabled until we better integrate QDM
    # test 'should show patients for api_v1_measure' do
    #   get :patients, id: @api_v1_measure
    #   assert_response :success
    #   json = JSON.parse(response.body)
    #   assert_equal @num_patients, json.size
    #   assert_equal ['No Diagnosis or Fac', 'No Fac', 'With Fac', 'With Fac No Code', 'With Fac No End', 'With Fac No Start', 'With Fac No Time'],
    #                json.map { |x| x['first'] }.sort
    # end

    # /measures/:id/patients is disabled until we better integrate QDM
    # test 'should not show patients for unknown measure' do
    #   get :patients, id: 'foo'
    #   assert_response :missing
    # end

    test 'should return bad_request when measure_file not provided' do
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      post :create, params: {calculation_type: 'episode'}
      assert_response :bad_request
      expected_response = { 'status' => 'error', 'messages' => 'Missing parameter: measure_file' }
      assert_equal expected_response, JSON.parse(response.body)
    end

    test 'should return bad_request when measure_file is not a file' do
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      post :create, params: {measure_file: 'not-a-file.gif', calculation_type: 'episode', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}
      assert_response :bad_request
      expected_response = { 'status' => 'error', 'messages' => "Invalid parameter 'measure_file': Must be a valid MAT Export." }
      assert_equal expected_response, JSON.parse(response.body)
    end

    test 'should return bad_request when measure_file is not a zip' do
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      not_zip_file = fixture_file_upload(File.join('test','fixtures','measures','CMS160v6','cqm_measures','CMS160v6.json'))
      post :create, params: {measure_file: not_zip_file, calculation_type: 'episode', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}
      assert_response :bad_request
      expected_response = { 'status' => 'error', 'messages' => "Invalid parameter 'measure_file': Must be a valid MAT Export." }
      assert_equal expected_response, JSON.parse(response.body)
    end

    test 'should return bad_request when the measure zip is not a MAT Export' do
      skip("UPDATE FOR NEW MODEL")
      measure_file = fixture_file_upload(File.join('test','fixtures','fhir_measures','UnitTest-non-MAT-export.zip'),'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('api_valid_vsac_response', @vcr_options) do
        post :create, params: {measure_file: measure_file, calculation_type: 'episode', vsac_tgt: ENV['VSAC_API_KEY'], vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}
        assert_response :bad_request
        expected_response = { 'status' => 'error', 'messages' => "Measure loading process encountered error: The uploaded measure bundle does not contain the proper FHIR JSON file." }
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test 'should return bad_request when calculation_type is invalid' do
      measure_file = fixture_file_upload(File.join('test','fixtures','fhir_measures','CMS104_v6_0_Artifacts.zip'),'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      post :create, params: {measure_file: measure_file, calculation_type: 'addition', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}
      assert_response :bad_request
      expected_response = { 'status' => 'error', 'messages' => "Invalid parameter 'calculation_type': Must be one of: <code>episode</code>, <code>patient</code>." }
      assert_equal expected_response, JSON.parse(response.body)
    end

    test 'should return bad_request when calculation_type is not provided' do
      measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      post :create, params: {measure_file: measure_file}
      assert_response :bad_request
      expected_response = { 'status' => 'error', 'messages' => 'Missing parameter: calculation_type' }
      assert_equal expected_response, JSON.parse(response.body)
    end

    test 'should create api_v1_measure initial' do
      skip("UPDATE FOR NEW MODEL")
      measure_file = fixture_file_upload(@test_file, 'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'

      measure = CQM::Measure.where({set_id: @test_set_id}).first
      assert_nil measure

      VCR.use_cassette('api_valid_vsac_response', @vcr_options) do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, calculation_type: 'patient'}
        assert_response :success
        expected_response = { 'status' => 'success', 'url' => "/api_v1/measures/#{@test_set_id}"}
        assert_equal expected_response, JSON.parse(response.body)
      end

      measure = CQM::Measure.where({set_id: @test_set_id}).first
      assert_equal '2c9280827505caf901750db2ef620221', measure['fhir_measure']['fhirId']
      assert_equal @user.id, measure.user_id
      assert_equal 'PATIENT', measure.calculation_method
    end

    test 'should error on duplicate measure' do
      skip("UPDATE FOR NEW MODEL")
      measure_file = fixture_file_upload(@test_file, 'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      vcr_options = @vcr_options
      # VCR, by default -> each response in a cassette can only be matched and played back once while the cassette is in use.
      # Permitting repeat playbacks since we are checking for duplicates.
      vcr_options[:allow_playback_repeats] = true
      VCR.use_cassette('api_valid_vsac_response', vcr_options) do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, calculation_type: 'patient'}
        assert_response :success
        expected_response = { 'status' => 'success', 'url' => "/api_v1/measures/#{@test_set_id}"}
        assert_equal expected_response, JSON.parse(response.body)

        # Attempting to re-use measure_file here caused a failure during Bonnie's measure parsing. Simply re-loading the same file to a different variable works.
        same_file = fixture_file_upload(@test_file, 'application/zip')
        post :create, params: {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: same_file, calculation_type: 'patient'}
        assert_response :conflict
        expected_response = { 'status' => 'error', 'messages' => 'A measure with this Set ID already exists.', 'url' => "/api_v1/measures/#{@test_set_id}"}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test 'should choose default titles for populations' do
      skip "VCR Cassette needs be updated with missing VSAC interactions."
      #TODO -- Update VCR cassette with missing VSAC calls.
      measure_file = fixture_file_upload(File.join('test','fixtures','fhir_measures','ContinuousFhir_v6_0_Artifacts.zip'),'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('api_valid_vsac_response', @vcr_options) do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, calculation_type: 'patient'}
        assert_response :ok
        expected_response = { 'status' => 'success', 'url' => '/api_v1/measures/81AC1377-E54D-420F-ACA7-4D902EA01F9D'}
        assert_equal expected_response, JSON.parse(response.body)

        measure = CQM::Measure.where({set_id: '81AC1377-E54D-420F-ACA7-4D902EA01F9D'}).first
        assert_equal 2, measure.population_sets.size
        assert_equal 2, measure.population_sets[0].stratifications.size

        assert_equal 'Population Criteria Selection', measure.population_sets[0].title
        assert_equal 'PopSet1 Stratification 1', measure.population_sets[0].stratifications[0].title
        assert_equal 'PopSet1 Stratification 2', measure.population_sets[0].stratifications[1].title
      end
    end

    test 'should use provided population titles for populations' do
      skip "VCR Cassette needs be updated with missing VSAC interactions."
      #TODO -- Update VCR cassette with missing VSAC calls.
      measure_file = fixture_file_upload(File.join('test','fixtures','fhir_measures','ContinuousFhir_v6_0_Artifacts.zip'),'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('api_valid_vsac_response_provided_titles', @vcr_options) do
        # get ticket_granting_ticket
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, calculation_type: 'episode', population_titles: ['First Pop', 'Second Pop', 'First Strat']}
        assert_response :ok
        expected_response = { 'status' => 'success', 'url' => '/api_v1/measures/116A8764-E871-472F-9503-CA27889114DE'}
        assert_equal expected_response, JSON.parse(response.body)

        measure = CQM::Measure.where({set_id: '116A8764-E871-472F-9503-CA27889114DE'}).first
        assert_equal 2, measure.population_sets.size
        assert_equal 2, measure.population_sets[0].stratifications.size
        assert_equal 1, measure.population_sets[1].observations.size # No Strats in 2nd pop set, contains only Observations.
        assert_equal 'First Pop', measure.population_sets[0].title
        assert_equal 'Second Pop', measure.population_sets[1].title
        assert_equal 'First Strat', measure.population_sets[0].stratifications[0].title
        assert_equal 'Second Strat', measure.population_sets[0].stratifications[1].title
      end
    end

    test 'should error on upload due to incorrect VSAC release parameter input' do
      skip("UPDATE FOR NEW MODEL")
      measure_file = fixture_file_upload(@test_file, 'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('api_invalid_release_vsac_response', @vcr_options) do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {vsac_query_type: 'release', vsac_query_release: 'Fake 1234', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, calculation_type: 'episode'}
        assert_response :bad_request
        expected_response = {'status'=>'error', 'messages'=>'VSAC value set (2.16.840.1.114222.4.11.837) not found or is empty. Please verify that you are using the correct profile or release and have VSAC authoring permissions if you are requesting draft value sets.'}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test 'should error on upload due to invalid VSAC ticket' do
      skip("UPDATE FOR NEW MODEL")
      measure_file = fixture_file_upload(@test_file, 'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('api_invalid_ticket_vsac_response', @vcr_options) do
        ticket = 'foo'
        post :create, params: {vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, calculation_type: 'episode'}
        assert_response :bad_request
        expected_response = {'status'=>'error', 'messages'=>'VSAC session expired. Please try again.'}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test 'should return 404 on updating non existent measure' do
      skip("UPDATE FOR NEW MODEL")
      measure_file = fixture_file_upload(@test_file, 'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('api_valid_vsac_response_non_exist_measure', @vcr_options) do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        put :update, params: {id: '762B1B52-40BF-4596-B34F-4963188E7FF7', vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, calculation_type: 'episode'}
        assert_response :not_found
        expected_response = { 'status' => 'error', 'messages' => 'No measure found for this Set ID.'}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test 'should return error on updating measure with incorrect set_id' do
      skip("UPDATE FOR NEW MODEL")
      measure_file = fixture_file_upload(@test_file, 'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      vcr_options = @vcr_options
      # VCR, by default -> each response in a cassette can only be matched and played back once while the cassette is in use.
      # Permitting repeat playbacks since we are checking for duplicates.
      vcr_options[:allow_playback_repeats] = true
      VCR.use_cassette('api_valid_vsac_response', vcr_options) do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]

        post :create, params: {measure_file: measure_file, calculation_type: 'patient', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM'}
        assert_response :success
        expected_response = { 'status' => 'success', 'url' => "/api_v1/measures/#{@test_set_id}"}
        assert_equal expected_response, JSON.parse(response.body)

        measure_update_file = fixture_file_upload(@test_file, 'application/zip')
        put :update, params: {id: '42bf391f-38a3-4c0f-9ece-dcd47e9609d9', measure_file: measure_update_file, calculation_type: 'episode', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM'}
        assert_response :not_found
        expected_response = { 'status' => 'error', 'messages' => 'No measure found for this Set ID.'}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    test 'should calculate supplemental data elements' do
      skip("UPDATE FOR NEW MODEL")
      measure_file = fixture_file_upload(@test_file, 'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('api_valid_vsac_response', @vcr_options) do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, calculation_type: 'episode', calculate_sdes: 'true'}
        assert_response :success
        measure = CQM::Measure.where({set_id: @test_set_id}).first
        assert_equal true, measure.calculate_sdes
      end
    end

    test 'should not calculate supplemental data elements' do
      skip("UPDATE FOR NEW MODEL")
      measure_file = fixture_file_upload(@test_file, 'application/zip')
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('api_valid_vsac_response', @vcr_options) do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: 'true', vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, calculation_type: 'episode', calculate_sdes: 'false'}
        assert_response :success
        measure = CQM::Measure.where({set_id: @test_set_id}).first
        assert_equal false, measure.calculate_sdes
      end
    end

    test 'upload composite cql then delete and then upload again' do
      skip "Bonnie-on-FHIR does not support composite measures."
      # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
      # when the cassette needs to be generated for the first time.
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts.zip'), 'application/xml')

      # Make sure db has only the initial fixture in it
      assert_equal 0, CQM::Measure.all.count

      # Sanity check
      measure = CQM::Measure.where({set_id: '244B4F52-C9CA-45AA-8BDB-2F005DA05BFC'}).first
      assert_nil measure

      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('valid_vsac_response_composite_api_initial', @vcr_options) do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {
          vsac_query_type: 'profile',
          vsac_query_profile: 'eCQM Update 2020-05-07',
          vsac_query_include_draft: 'false',
          vsac_query_measure_defined: 'true',
          measure_file: measure_file,
          calculation_type: 'patient',
          vsac_tgt: ticket,
          vsac_tgt_expires_at: @ticket_expires_at
        }
      end
      assert_response :success
      expected_response = { 'status' => 'success', 'url' => '/api_v1/measures/244B4F52-C9CA-45AA-8BDB-2F005DA05BFC'}
      assert_equal expected_response, JSON.parse(response.body)

      measure = CQM::Measure.where({composite: true}).first
      assert_equal '40280582-6621-2797-0166-4034035B100A', measure['hqmf_id']
      # This composite measure has 7 components and 1 composite measure + initial fixture
      assert_equal 8, CQM::Measure.all.count

      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('valid_vsac_response_composite_api_again', @vcr_options) do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :update, params: {
          vsac_query_type: 'profile',
          id: '244B4F52-C9CA-45AA-8BDB-2F005DA05BFC',
          vsac_query_profile: 'Latest eCQM',
          vsac_query_include_draft: 'false',
          vsac_query_measure_defined: 'true',
          measure_file: measure_file,
          calculation_type: 'patient',
          vsac_tgt: ticket,
          vsac_tgt_expires_at: @ticket_expires_at
        }
      end
      assert_response :success
      expected_response = { 'status' => 'success', 'url' => '/api_v1/measures/244B4F52-C9CA-45AA-8BDB-2F005DA05BFC'}
      assert_equal expected_response, JSON.parse(response.body)

      measure = CQM::Measure.where({composite: true}).first
      assert_equal '40280582-6621-2797-0166-4034035B100A', measure['hqmf_id']
      # This composite measure has 7 components and 1 composite measure + initial fixture
      assert_equal 8, CQM::Measure.all.count
    end

    test 'upload invalid composite measure, missing eCQM file' do
      skip "Bonnie-on-FHIR does not support composite measures."
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts_missing_file.zip'), 'application/xml')
      class << measure_file
        attr_reader :tempfile
      end
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('valid_vsac_response_bad_composite_api', @vcr_options) do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {
          vsac_query_type: 'profile',
          vsac_query_profile: 'Latest eCQM',
          vsac_query_include_draft: 'false',
          vsac_query_measure_defined: 'true',
          measure_file: measure_file,
          calculation_type: 'patient',
          vsac_tgt: ticket,
          vsac_tgt_expires_at: @ticket_expires_at
        }
      end

      assert_response :bad_request
      expected_response = {'status'=>'error', 'messages'=>"Invalid parameter 'measure_file': Must be a valid MAT Export."}
      assert_equal expected_response, JSON.parse(response.body)
    end

    test 'upload invalid composite measure, missing component' do
      skip "Bonnie-on-FHIR does not support composite measures."
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts_missing_component.zip'), 'application/xml')
      class << measure_file
        attr_reader :tempfile
      end
      @request.env['CONTENT_TYPE'] = 'multipart/form-data'
      VCR.use_cassette('valid_vsac_response_bad_composite_api', @vcr_options) do
        api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: ENV['VSAC_API_KEY'])
        ticket = api.ticket_granting_ticket[:ticket]
        post :create, params: {
          vsac_query_type: 'profile',
          vsac_query_profile: 'Latest eCQM',
          vsac_query_include_draft: 'false',
          vsac_query_measure_defined: 'true',
          measure_file: measure_file,
          calculation_type: 'patient',
          vsac_tgt: ticket,
          vsac_tgt_expires_at: @ticket_expires_at
        }
      end
      assert_response :bad_request
      expected_response = {'status'=>'error', 'messages'=>"Measure loading process encountered error: Elm library AnnualWellnessAssessmentPreventiveCareScreeningforFallsRisk referenced but not found."}
      assert_equal expected_response, JSON.parse(response.body)
    end
  end
end
