require 'test_helper'

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
      cms347_fixtures = File.join("cql_measures", "CMS347v1"), File.join("records", "CMS347v1")
      cms160_fixtures = File.join("cql_measures","core_measures", "CMS160v6"), File.join("records", "core_measures", "CMS160v6"), File.join("health_data_standards_svs_value_sets", "core_measures", "CMS160v6")
      collection_fixtures(users_set, *cms347_fixtures, *cms160_fixtures)
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


    test "should calculate result json" do
      VCR.use_cassette("backend_calculation_json") do
        measure_id = CqlMeasure.where({"cms_id" => "CMS160v6"}).first.hqmf_set_id
        get :calculated_results, id: measure_id
        assert_response :success
        assert_equal response.content_type, 'application/json'
        json = JSON.parse(response.body)

        assert_equal 2, json.count
        assert_equal 1, json["5a9ee716b848465b0064f52c"]["PopulationCriteria1"]["IPP"]
        assert_equal 0, json["5a9ee716b848465b0064f52c"]["PopulationCriteria1"]["NUMER"]
      end
    end

    test "should calculate result excel sheet" do
      VCR.use_cassette("backend_calculation_excel") do
        measure_id = CqlMeasure.where({"cms_id" => "CMS160v6"}).first.hqmf_set_id
        headers = { :Accept => "xlsx" }
        request.headers.merge! headers
        get :calculated_results, id: measure_id
        assert_response :success
        assert_equal 'binary', response.header['Content-Transfer-Encoding']
        filename = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/.match(response.header["Content-Disposition"])[1][1..-2]
        assert_equal 'CMS160v6.xlsx', filename
        temp = Tempfile.new(["test", ".xlsx"])
        temp.write(response.body)
        temp.rewind()
        doc = Roo::Spreadsheet.open(temp.path)

        assert_equal "\nKEY\n", doc.sheet("KEY").row(1)[0]
        assert_equal 1.0, doc.sheet("Population 1").row(3)[0]
      end
    end
  end
end
