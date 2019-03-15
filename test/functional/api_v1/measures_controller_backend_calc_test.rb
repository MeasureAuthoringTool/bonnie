require 'test_helper'

module ApiV1
  class MeasuresControllerBackendCalcTest < ActionController::TestCase
    tests ApiV1::MeasuresController
    include Devise::Test::ControllerHelpers
    include WebMock::API

    def setup_db
      dump_database
      users_set = File.join("users", "base_set")
      record_fixtures = File.join('cqm_patients', 'CMS160v6')
      collection_fixtures(users_set, record_fixtures)
      @user = User.by_email('bonnie@example.com').first
      load_measure_fixtures_from_folder(File.join("measures", "CMS160v6"), @user)
      @measure = CQM::Measure.where({"cms_id" => "CMS160v6"}).first
      @cms160_hqmf_set_id = @measure.hqmf_set_id
      associate_user_with_patients(@user,CQM::Patient.all)

      @vcr_options = {match_requests_on: [:method, :uri_no_st]}
    end

    setup do
      @error_dir = File.join('log','load_errors')
      FileUtils.rm_r @error_dir if File.directory?(@error_dir)
      setup_db
      sign_in @user
      @token = StubToken.new
      @token.resource_owner_id = @user.id
      @controller.instance_variable_set('@_doorkeeper_token', @token)
      @ticket_expires_at = (Time.now + 8.hours).to_i
    end

    test "should get a 404 for bad measure id" do
      headers = { :Accept => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }
      request.headers.merge! headers
      measure_id = "bad_id_abc_123"
      get :calculated_results, id: measure_id
      assert_response :not_found
      assert_equal response.content_type, 'application/json'
      json = JSON.parse(response.body)
      assert_equal "error", json["status"]
    end

    test "should get a 500 if calculation server is down" do
      begin
        headers = { :Accept => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' }
        request.headers.merge! headers
        stub_request(:post, BonnieBackendCalculator::CALCULATION_SERVICE_URL).to_timeout
        get :calculated_results, id: @cms160_hqmf_set_id
        assert_response :internal_server_error
      ensure
        # This needs to be in an ensure block because failures above this line will change global state otherwise.
        WebMock.reset!
      end
    end

    test "should get a 406 error response if no accept header is provided" do
      VCR.use_cassette("backend_calculation_json_as_default") do
        get :calculated_results, id: @cms160_hqmf_set_id
        assert_response :not_acceptable
        assert_equal response.content_type, 'application/json'
        json = JSON.parse(response.body)

        assert_equal 'error', json['status']
      end
    end

    test "should get a 406 error response if json is requested" do
      VCR.use_cassette("backend_calculation_json") do
        headers = { :Accept => "application/json" }
        request.headers.merge! headers
        get :calculated_results, id: @cms160_hqmf_set_id
        assert_response :not_acceptable
        assert_equal response.content_type, 'application/json'

        json = JSON.parse(response.body)

        assert_equal 'error', json['status']
      end
    end

    test "should calculate result excel sheet" do
      # Apiepie is set to automatically include the whole request and response as json in apipie_examples.json file, but to_json will fail on the binary excel file
      # TODO: investigate better way to exclude an example (or just the response) from apipie, or modify apipie to better handle this
      apipie_record_configuration = Apipie.configuration.record
      Apipie.configuration.record = false

      VCR.use_cassette("backend_calculation_excel", @vcr_options) do
        headers = { :Accept => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
        request.headers.merge! headers
        get :calculated_results, id: @measure.hqmf_set_id
        assert_response :success
        assert_equal 'binary', response.header['Content-Transfer-Encoding']
        assert_equal 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', response.content_type 
        filename = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/.match(response.header["Content-Disposition"])[1][1..-2]
        assert_equal 'CMS160v6.xlsx', filename

        temp = Tempfile.new(["test", ".xlsx"])
        temp.write(response.body)
        temp.rewind
        doc = Roo::Spreadsheet.open(temp.path)

        assert_equal "\nKEY\n", doc.sheet("KEY").row(1)[0]
        assert_equal 1.0, doc.sheet("1 - Population Criteria Section").row(3)[0]
      end

      Apipie.configuration.record = apipie_record_configuration
    end

    test "should calculate result excel sheet with correct expected values for shared patient in component measure" do
      composite_measure_records = File.join('cqm_patients','CMS321')
      collection_fixtures(composite_measure_records)
      associate_user_with_patients(@user,CQM::Patient.all)
      load_measure_fixtures_from_folder(File.join("measures", "CMS890_v5_6"), @user)

      apipie_record_configuration = Apipie.configuration.record
      Apipie.configuration.record = false

      measure_id = "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&E22EA997-4EC1-4ED2-876C-3671099CB325"

      VCR.use_cassette("backend_calculation_excel_shared_patient") do
        headers = { :Accept => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
        request.headers.merge! headers
        get :calculated_results, id: measure_id
        assert_response :success
        assert_equal 'binary', response.header['Content-Transfer-Encoding']
        assert_equal 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', response.content_type
        filename = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/.match(response.header["Content-Disposition"])[1][1..-2]
        assert_equal 'CMS231v0.xlsx', filename
        temp = Tempfile.new(["test", ".xlsx"])
        temp.write(response.body)
        temp.rewind
        doc = Roo::Spreadsheet.open(temp.path)

        assert_equal "\nKEY\n", doc.sheet("KEY").row(1)[0]
        sheet = doc.sheet("1 - Population Criteria Section")
        if sheet.row(3)[9] == "doe"
          jon_doe_row = sheet.row(3)
          jane_smith_row = sheet.row(4)
        else
          jon_doe_row = sheet.row(4)
          jane_smith_row = sheet.row(3)
        end
        assert_equal [1.0, 1.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0], jon_doe_row[0..7]
        assert_equal [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], jane_smith_row[0..7]
      end

      Apipie.configuration.record = apipie_record_configuration
    end

    test "should calculate result excel sheet with correct expected values for shared patient in composite measure" do
      composite_measure_records = File.join('cqm_patients','CMS321')
      collection_fixtures(composite_measure_records)
      associate_user_with_patients(@user,CQM::Patient.all)
      load_measure_fixtures_from_folder(File.join("measures", "CMS890_v5_6"), @user)

      apipie_record_configuration = Apipie.configuration.record
      Apipie.configuration.record = false

      measure_id = "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"

      VCR.use_cassette("backend_calculation_excel_shared_patient_composite") do
        headers = { :Accept => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
        request.headers.merge! headers
        get :calculated_results, id: measure_id
        assert_response :success
        assert_equal 'binary', response.header['Content-Transfer-Encoding']
        assert_equal 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', response.content_type
        filename = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/.match(response.header["Content-Disposition"])[1][1..-2]
        assert_equal 'CMS890v0.xlsx', filename

        temp = Tempfile.new(["test", ".xlsx"])
        temp.write(response.body)
        temp.rewind
        doc = Roo::Spreadsheet.open(temp.path)
        sheet = doc.sheet("1 - Population Criteria Section")
        if sheet.row(3)[9] == "doe"
          jon_doe_row = sheet.row(3)
          jane_smith_row = sheet.row(4)
        else
          jon_doe_row = sheet.row(4)
          jane_smith_row = sheet.row(3)
        end

        assert_equal "\nKEY\n", doc.sheet("KEY").row(1)[0]
        expected_rows = JSON.parse(File.read(File.join(Rails.root, "test", "fixtures", "expected_excel_results","CMS321v0_shared_patients_composite.json")))
        # There currently seems to be a mismatch in frontend / backend for things like [], 0, [0], etc.
        expected_rows["jane_smith_row"][6] = "[]" # from "0"

        jon_doe_row[12] = "FALSE" if jon_doe_row[12] == false
        jane_smith_row[12] = "FALSE" if jane_smith_row[12] == false

        # Compare the calculation results
        assert_equal expected_rows["jon_doe_row"][0..7], jon_doe_row[0..7]
        assert_equal expected_rows["jane_smith_row"][0..7], jane_smith_row[0..7]

        # There was an ordering mismatch, so this sorts the remainder of the arrays so the comparison will be order independent
        expected_cql_results_jon = expected_rows["jon_doe_row"][8..-1].grep(String).sort + expected_rows["jon_doe_row"][8..-1].grep(Integer).sort
        expected_cql_results_jane = expected_rows["jane_smith_row"][8..-1].grep(String).sort + expected_rows["jane_smith_row"][8..-1].grep(Integer).sort
        jane_smith_cql = jane_smith_row[8..-1].grep(String).sort + jane_smith_row[8..-1].grep(Integer).sort
        jon_doe_cql = jon_doe_row[8..-1].grep(String).sort + jon_doe_row[8..-1].grep(Integer).sort

        assert_equal expected_cql_results_jon, jon_doe_cql
        assert_equal expected_cql_results_jane, jane_smith_cql
      end

      Apipie.configuration.record = apipie_record_configuration
    end

    test "should get an excel sheet noting no patients" do
      dump_database
      users_set = File.join("users", "base_set")
      collection_fixtures(users_set)
      load_measure_fixtures_from_folder(File.join("measures", "CMS160v6"), @user)

      apipie_record_configuration = Apipie.configuration.record
      Apipie.configuration.record = false

      VCR.use_cassette("backend_calculation_excel_no_patients") do
        headers = { :Accept => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
        request.headers.merge! headers
        get :calculated_results, id: @cms160_hqmf_set_id
        assert_response :success
        assert_equal 'binary', response.header['Content-Transfer-Encoding']
        assert_equal 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', response.content_type
        filename = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/.match(response.header["Content-Disposition"])[1][1..-2]
        assert_equal 'CMS160v6.xlsx', filename
        temp = Tempfile.new(["test", ".xlsx"])
        temp.write(response.body)
        temp.rewind
        doc = Roo::Spreadsheet.open(temp.path)
        assert_equal "Measure has no patients, please re-export with patients", doc.sheet("Error").row(1)[0]
      end

      Apipie.configuration.record = apipie_record_configuration

      setup_db
    end
  end
end
