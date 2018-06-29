require 'test_helper'
# These tests were in the QDM-based measures tests but are not in the CQL-based measures tests below:
#    test "should error on create measure from hqmf xml without vsac creds"
#    test "should get calculated_results as json for api_v1_measure"
#    test "should not get calculated_results for unknown measure"
#    test "should return bad request on episode of care measurement with no specific occurrence"
#    test "should return bad_request when measure_file is not a .zip or .xml"
#    test "should update api_v1_measure"
module ApiV1
  class MeasuresControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    # StubToken simulates an OAuth2 token... we're not actually
    # verifying that a token was issued. This test completely
    # bypasses OAuth2 authentication and authorization provided
    # by Doorkeeper.
    class StubToken
      attr_accessor :resource_owner_id
      def acceptable?(_value)
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
      @ticket_expires_at = (Time.now + 8.hours).to_i
    end

    # test "should get index as html" do
    #   get :index
    #   assert_response :success
    #   assert_equal response.content_type, 'text/html'
    #   assert_not_nil assigns(:api_v1_measures)
    # end
    #
    # test "should get index as json" do
    #   get :index, :format => "json"
    #   assert_response :success
    #   assert_equal response.content_type, 'application/json'
    #   json = JSON.parse(response.body)
    #   assert_equal 1, json.size
    #   assert_equal [], (json.map { |x| x['cms_id'] } - ['CMS347v1'])
    #   assert_not_nil assigns(:api_v1_measures)
    # end
    #
    # test "should show api_v1_measure" do
    #   get :show, id: @api_v1_measure
    #   assert_response :success
    #   assert_equal response.content_type, 'application/json'
    #   json = JSON.parse(response.body)
    #   assert_equal 'CMS347v1', json['cms_id']
    #   assert_not_nil assigns(:api_v1_measure)
    # end
    #
    # test "should not show unknown measure" do
    #   get :show, id: 'foo'
    #   assert_response :missing
    # end
    #
    # test "should show patients for api_v1_measure" do
    #   get :patients, id: @api_v1_measure
    #   assert_response :success
    #   json = JSON.parse(response.body)
    #   assert_equal @num_patients, json.size
    #   assert_equal ["No Diagnosis or Fac", "No Fac", "With Fac", "With Fac No Code", "With Fac No End", "With Fac No Start", "With Fac No Time"],
    #                json.map { |x| x["first"] }.sort
    # end
    #
    # test "should not show patients for unknown measure" do
    #   get :patients, id: 'foo'
    #   assert_response :missing
    # end
    #
    # test "should return bad_request when measure_file not provided" do
    #   @request.env["CONTENT_TYPE"] = "multipart/form-data"
    #   post :create, {measure_type: 'eh', calculation_type: 'episode'}
    #   assert_response :bad_request
    #   expected_response = { "status" => "error", "messages" => "Missing parameter: measure_file" }
    #   assert_equal expected_response, JSON.parse(response.body)
    # end
    #
    # test "should return bad_request when measure_file is not a file" do
    #   @request.env["CONTENT_TYPE"] = "multipart/form-data"
    #   post :create, {measure_file: 'not-a-file.gif', measure_type: 'eh', calculation_type: 'episode', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}, {format: 'multipart/form-data'}
    #   assert_response :bad_request
    #   expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_file': Must be a valid MAT Export." }
    #   assert_equal expected_response, JSON.parse(response.body)
    # end
    #
    # test "should return bad_request when the measure zip is not a MAT Export" do
    #   measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','special_measures','not_mat_export.zip'),'application/zip')
    #   @request.env["CONTENT_TYPE"] = "multipart/form-data"
    #   post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}, {"Content-Type" => 'multipart/form-data'}
    #   assert_response :bad_request
    #   expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_file': Must be a valid MAT Export." }
    #   assert_equal expected_response, JSON.parse(response.body)
    # end
    #
    # test "should return bad_request when measure_type is invalid" do
    #   measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','CMS52_v5_4_Artifacts.zip'),'application/zip')
    #   @request.env["CONTENT_TYPE"] = "multipart/form-data"
    #   post :create, {measure_file: measure_file, measure_type: 'no', calculation_type: 'episode', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}, {"Content-Type" => 'multipart/form-data'}
    #   assert_response :bad_request
    #   expected_response = { "status" => "error", "messages" => "Invalid parameter 'measure_type': Must be one of: <code>eh</code>, <code>ep</code>." }
    #   assert_equal expected_response, JSON.parse(response.body)
    # end
    #
    # test "should return bad_request when calculation_type is invalid" do
    #   measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','CMS52_v5_4_Artifacts.zip'),'application/zip')
    #   @request.env["CONTENT_TYPE"] = "multipart/form-data"
    #   post :create, {measure_file: measure_file, measure_type: 'ep', calculation_type: 'addition', vsac_tgt: 'foo', vsac_tgt_expires_at: @ticket_expires_at, vsac_query_type: 'profile'}, {"Content-Type" => 'multipart/form-data'}
    #   assert_response :bad_request
    #   expected_response = { "status" => "error", "messages" => "Invalid parameter 'calculation_type': Must be one of: <code>episode</code>, <code>patient</code>." }
    #   assert_equal expected_response, JSON.parse(response.body)
    # end
    #
    # test "should return bad_request when calculation_type is not provided" do
    #   measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    #   @request.env["CONTENT_TYPE"] = "multipart/form-data"
    #   post :create, {measure_file: measure_file, measure_type: 'ep'}
    #   assert_response :bad_request
    #   expected_response = { "status" => "error", "messages" => "Missing parameter: calculation_type" }
    #   assert_equal expected_response, JSON.parse(response.body)
    # end
    #
    # test "should create api_v1_measure initial" do
    #   measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_Artifacts.zip'),'application/zip')
    #   @request.env["CONTENT_TYPE"] = "multipart/form-data"
    #
    #   measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
    #   assert_nil measure
    #
    #   VCR.use_cassette("api_valid_vsac_response") do
    #     # get ticket_granting_ticket
    #     ticket = String.new(HealthDataStandards::Util::VSApi.get_tgt_using_credentials(ENV['VSAC_USERNAME'],ENV['VSAC_PASSWORD'], "https://vsac.nlm.nih.gov/vsac/ws/Ticket"))
    #     post :create, {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: true, vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'}, {"Content-Type" => 'multipart/form-data'}
    #     assert_response :success
    #     expected_response = { "status" => "success", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
    #     assert_equal expected_response, JSON.parse(response.body)
    #   end
    #
    #   measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
    #   assert_equal "40280582-5859-673B-0158-DAEF8B750647", measure['hqmf_id']
    #   assert_equal @user.id, measure.user_id
    #   measure.value_sets.each {|vs| assert_equal @user.id, vs.user_id}
    #   assert_equal false, measure.episode_of_care?
    #   assert_equal 'ep', measure.type
    # end
    #
    # test "should error on duplicate measure" do
    #   measure_file = fixture_file_upload(File.join('test','fixtures','cql_measure_exports','IETCQL_v5_0_Artifacts.zip'),'application/zip')
    #   @request.env["CONTENT_TYPE"] = "multipart/form-data"
    #   VCR.use_cassette("api_valid_vsac_response") do
    #     # get ticket_granting_ticket
    #     ticket = String.new(HealthDataStandards::Util::VSApi.get_tgt_using_credentials(ENV['VSAC_USERNAME'],ENV['VSAC_PASSWORD'], "https://vsac.nlm.nih.gov/vsac/ws/Ticket"))
    #     post :create, {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: true, vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'}, {"Content-Type" => 'multipart/form-data'}
    #     assert_response :success
    #     expected_response = { "status" => "success", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
    #     assert_equal expected_response, JSON.parse(response.body)
    #   end
    #
    #   @request.env["CONTENT_TYPE"] = "multipart/form-data"
    #   VCR.use_cassette("api_valid_vsac_response") do
    #     # get ticket_granting_ticket
    #     ticket = String.new(HealthDataStandards::Util::VSApi.get_tgt_using_credentials(ENV['VSAC_USERNAME'],ENV['VSAC_PASSWORD'], "https://vsac.nlm.nih.gov/vsac/ws/Ticket"))
    #     post :create, {vsac_query_type: 'profile', vsac_query_profile: 'Latest eCQM', vsac_query_measure_defined: true, vsac_tgt: ticket, vsac_tgt_expires_at: @ticket_expires_at, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'}, {"Content-Type" => 'multipart/form-data'}
    #     assert_response :conflict
    #     expected_response = { "status" => "error", "messages" => "A measure with this HQMF Set ID already exists.", "url" => "/api_v1/measures/762B1B52-40BF-4596-B34F-4963188E7FF7"}
    #     assert_equal expected_response, JSON.parse(response.body)
    #   end
    # end

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

    test "should error on create measure from hqmf xml with expired ticket" do
      VCR.use_cassette("bad_vsac_creds") do
        measure_file = fixture_file_upload(File.join('testplan','435ComplexV2_v4_SimpleXML.xml'),'application/xml')
        @request.env["CONTENT_TYPE"] = "multipart/form-data"
        post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', population_titles: ['First Pop', 'Second Pop', 'Only Strat'], vsac_tgt: "bad ticket", vsac_tgt_expires_at: (Time.now - 3.hours).to_i}
        assert_response :internal_server_error
        expected_response = { "status" => "error", "messages" => "VSAC ticket granting ticket appears to have expired."}
        assert_equal expected_response, JSON.parse(response.body)
      end
    end

    # test "should get calculated_results as xlsx for api_v1_measure" do
    #   @request.env['HTTP_ACCEPT'] = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    #   get :calculated_results, id: @api_v1_measure
    #
    #   assert_equal 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', response.content_type
    #
    #   excel_file = File.open("#{Rails.root}/public/resource/Sample_Excel_Export(CMS52v6).xlsx", "rb")
    #   excel_binary = excel_file.read
    #
    #   assert_equal response.body, excel_binary
    #   excel_file.close
    # end
    #
    # test "should get unimplemented message for calculated_results as json" do
    #   get :calculated_results, id: @api_v1_measure
    #   assert_response :bad_request
    #   assert_equal JSON.parse(response.body)['messages'], "Unimplemented functionality"
    # end
  end
end
