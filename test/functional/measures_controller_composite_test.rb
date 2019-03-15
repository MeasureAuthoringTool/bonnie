require 'test_helper'
require 'vcr_setup.rb'

class MeasuresControllerCompositeTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  tests MeasuresController

  setup do
    @error_dir = File.join('log', 'load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    users_set = File.join("users", "base_set")
    measures_set = File.join("draft_measures", "base_set")
    records_set = File.join('cqm_patients','CMS32v7')
    collection_fixtures(measures_set, users_set, records_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_patients(@user, CQM::Patient.all)
    associate_user_with_measures(@user, Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
    sign_in @user
    @vcr_options = {match_requests_on: [:method, :uri_no_st]}
  end

  test "upload composite cql then delete and then upload again" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts.zip'), 'application/xml')

    # Make sure db is clean
    assert_equal 0, CQM::Measure.all.count

    # Sanity check
    measure = CQM::Measure.where({hqmf_set_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"}).first
    assert_nil measure

    VCR.use_cassette("valid_vsac_response_composite", @vcr_options) do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient',
        continuous_variable: true
      }
    end

    assert_response :redirect

    measure = CQM::Measure.where({composite: true}).first
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']
    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CQM::Measure.all.count

    post :destroy, {
      id: measure.id
    }
    assert_response :success
    assert_equal 0, CQM::Measure.all.count

    VCR.use_cassette("valid_vsac_response_composite", @vcr_options) do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient',
        continuous_variable: true
      }
    end
    assert_response :redirect

    measure = CQM::Measure.where({composite: true}).first
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']
    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CQM::Measure.all.count
  end

  test "upload invalid composite measure, missing hqmf file" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts_missing_file.zip'), 'application/xml')
    class << measure_file
      attr_reader :tempfile
    end
    VCR.use_cassette("valid_vsac_response_composite", @vcr_options) do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'eh',
        calculation_type: 'episode'
      }
    end
    assert_equal "Error Uploading Measure", flash[:error][:title]
    assert_equal "The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.", flash[:error][:summary]
    assert_equal "Measure loading process encountered error: Error processing package file: Measure folder found with no hqmf Please re-package and re-export your measure from the MAT.<br/>If this is a QDM-Logic Based measure, please use <a href='https://bonnie-qdm.healthit.gov'>Bonnie-QDM</a>.", flash[:error][:body]
    assert_response :redirect
  end

  test "upload invalid composite measure, missing component" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts_missing_component.zip'), 'application/xml')
    class << measure_file
      attr_reader :tempfile
    end
    VCR.use_cassette("valid_vsac_response_composite", @vcr_options) do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
    end
    assert_equal 'Error Uploading Measure', flash[:error][:title]
    assert_equal 'The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.', flash[:error][:summary]
    assert_equal "Measure loading process encountered error: Elm library AnnualWellnessAssessmentPreventiveCareScreeningforFallsRisk referenced but not found. Please re-package and re-export your measure from the MAT.<br/>If this is a QDM-Logic Based measure, please use <a href='https://bonnie-qdm.healthit.gov'>Bonnie-QDM</a>.", flash[:error][:body]
    assert_response :redirect
  end

  test "update composite measure with mismatching hqmf_set_id" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts.zip'), 'application/xml')

    # Make sure db is clean
    assert_equal 0, CQM::Measure.all.count

    # Sanity check
    measure = CQM::Measure.where({hqmf_set_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"}).first
    assert_nil measure

    VCR.use_cassette("valid_vsac_response_composite", @vcr_options) do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
    end
    assert_response :redirect

    measure = CQM::Measure.where({composite: true}).first
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']
    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CQM::Measure.all.count

    # Update previously loaded measure with a measure that has a different hqmf_set_id
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts_hqmf_set_id_mismatch.zip'), 'application/xml')

    VCR.use_cassette("valid_vsac_response_composite", @vcr_options) do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient',
        hqmf_set_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"
      }
    end
    assert_equal "Error Updating Measure", flash[:error][:title]
    assert_equal "The update file does not match the measure.", flash[:error][:summary]
    assert_equal "You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure.", flash[:error][:body]
    assert_response :redirect

    assert_equal 8, CQM::Measure.all.count
  end

  test "upload composite cql then try to delete a component" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts.zip'), 'application/xml')

    # Make sure db is clean
    assert_equal 0, CQM::Measure.all.count

    # Sanity check
    measure = CQM::Measure.where({hqmf_set_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"}).first
    assert_nil measure

    VCR.use_cassette("valid_vsac_response_composite", @vcr_options) do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
    end
    assert_response :redirect

    measure = CQM::Measure.where({composite: true}).first
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']
    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CQM::Measure.all.count

    # Get a component measure
    component = CQM::Measure.where({component: true}).first
    post :destroy, {
      id: component.id
    }
    assert_response :bad_request
    # Make sure nothing got deleted
    assert_equal 8, CQM::Measure.all.count
  end

  test "upload composite cql then update it" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts.zip'), 'application/xml')

    # Make sure db is clean
    assert_equal 0, CQM::Measure.all.count

    # Sanity check
    measure = CQM::Measure.where({hqmf_set_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"}).first
    assert_nil measure

    VCR.use_cassette("valid_vsac_response_composite", @vcr_options) do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
    end
    assert_response :redirect

    measure = CQM::Measure.where({composite: true}).first
    id = measure['id']
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']
    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CQM::Measure.all.count

    # Reupload the measure
    VCR.use_cassette("valid_vsac_response_composite", @vcr_options) do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient',
        hqmf_set_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"
      }
    end
    assert_response :redirect
    measure = CQM::Measure.where({composite: true}).first
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']

    # Proves that the composite measure has actually been updated
    assert_not_equal id, measure['id']

    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CQM::Measure.all.count
  end
end
