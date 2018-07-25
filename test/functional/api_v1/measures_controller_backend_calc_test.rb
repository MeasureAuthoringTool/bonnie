require 'test_helper'

module ApiV1
  class MeasuresControllerBackendCalcTest < ActionController::TestCase
    tests ApiV1::MeasuresController
    include Devise::TestHelpers

    setup do
      @error_dir = File.join('log','load_errors')
      FileUtils.rm_r @error_dir if File.directory?(@error_dir)
      dump_database
      users_set = File.join("users", "base_set")
      cms160_fixtures = File.join("cql_measures","core_measures", "CMS160v6"), File.join("records", "core_measures", "CMS160v6"), File.join("health_data_standards_svs_value_sets", "core_measures", "CMS160v6")
      collection_fixtures(users_set, *cms160_fixtures)
      @measure = CqlMeasure.where({"cms_id" => "CMS160v6"}).first
      @cms160_hqmf_set_id = @measure.hqmf_set_id
      @user = User.by_email('bonnie@example.com').first
      associate_user_with_measures(@user,CqlMeasure.all)
      associate_user_with_patients(@user,Record.all)
      associate_user_with_value_sets(@user,HealthDataStandards::SVS::ValueSet)
      sign_in @user
      @token = StubToken.new
      @token.resource_owner_id = @user.id
      @controller.instance_variable_set('@_doorkeeper_token', @token)
      @ticket_expires_at = (Time.now + 8.hours).to_i
    end

    test "should get a 404" do
      measure_id = "bad_id_abc_123"
      get :calculated_results, id: measure_id
      assert_response :not_found
      assert_equal response.content_type, 'application/json'
      json = JSON.parse(response.body)
      assert_equal "error", json["status"]
    end

    test "should calculate result in json as default" do
      VCR.use_cassette("backend_calculation_json_as_default") do
        get :calculated_results, id: @cms160_hqmf_set_id
        assert_response :success
        assert_equal response.content_type, 'application/json'
        json = JSON.parse(response.body)

        assert_equal 2, json.count
        assert_equal 1, json["5a9ee716b848465b0064f52c"]["PopulationCriteria1"]["IPP"]
        assert_equal 0, json["5a9ee716b848465b0064f52c"]["PopulationCriteria1"]["NUMER"]
      end
    end

    test "should calculate and return json if requested" do
      VCR.use_cassette("backend_calculation_json") do
        headers = { :Accept => "application/json" }
        request.headers.merge! headers
        get :calculated_results, id: @cms160_hqmf_set_id
        assert_response :success
        assert_equal response.content_type, 'application/json'
      end
    end

    test "should calculate result excel sheet" do
      # Apiepie is set to automatically include the whole request and response as json in apipie_examples.json file, but to_json will fail on the binary excel file
      # TODO: investigate better way to exclude an example (or just the response) from apipie, or modify apipie to better handle this
      apipie_record_configuration = Apipie.configuration.record
      Apipie.configuration.record = false

      VCR.use_cassette("backend_calculation_excel") do
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

        assert_equal "\nKEY\n", doc.sheet("KEY").row(1)[0]
        assert_equal 1.0, doc.sheet("Population 1").row(3)[0]
      end

      Apipie.configuration.record = apipie_record_configuration
    end
  end
end
