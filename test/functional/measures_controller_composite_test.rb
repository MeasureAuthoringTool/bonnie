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
    records_set = File.join("records","base_set")
    collection_fixtures(measures_set, users_set, records_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_patients(@user, Record.all)
    associate_user_with_measures(@user, Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
    sign_in @user
  end

  test "upload composite cql then delete and then upload again" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts.zip'), 'application/xml')

    # Make sure db is clean
    assert_equal 0, CqlMeasure.all.count

    # Sanity check
    measure = CqlMeasure.where({hqmf_set_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"}).first
    assert_nil measure

    VCR.use_cassette("valid_vsac_response_composite") do
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

    measure = CqlMeasure.where({composite: true}).first
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']
    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CqlMeasure.all.count

    post :destroy, {
      id: measure.id
    }
    assert_response :success
    assert_equal 0, CqlMeasure.all.count
    
    VCR.use_cassette("valid_vsac_response_composite") do
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
    
    measure = CqlMeasure.where({composite: true}).first
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']
    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CqlMeasure.all.count
  end

  test "upload invalid composite measure, missing eCQM file" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts_missing_file.zip'), 'application/xml')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_equal "Error Uploading Measure", flash[:error][:title]
    assert_equal "The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.", flash[:error][:summary]
    assert_equal 'Please re-package and re-export your measure from the MAT.<br/>.', flash[:error][:body]
    assert_response :redirect
  end

  test "upload invalid composite measure, missing component" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts_missing_component.zip'), 'application/xml')
    class << measure_file
      attr_reader :tempfile
    end
    VCR.use_cassette("valid_vsac_response_bad_composite") do
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
    assert_equal 'Error Loading Measure', flash[:error][:title]
    assert_equal 'The measure could not be loaded.', flash[:error][:summary]
    assert_equal 'Bonnie has encountered an error while trying to load the measure.', flash[:error][:body]
    assert_response :redirect
  end

  test "update composite measure with mismatching hqmf_set_id" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts.zip'), 'application/xml')

    # Make sure db is clean
    assert_equal 0, CqlMeasure.all.count

    # Sanity check
    measure = CqlMeasure.where({hqmf_set_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"}).first
    assert_nil measure

    VCR.use_cassette("valid_vsac_response_composite") do
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

    measure = CqlMeasure.where({composite: true}).first
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']
    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CqlMeasure.all.count

    # Update previously loaded measure with a measure that has a different hqmf_set_id
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts_hqmf_set_id_mismatch.zip'), 'application/xml')
    
    VCR.use_cassette("valid_vsac_response_composite") do
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
    
    assert_equal 8, CqlMeasure.all.count
  end

  test "upload composite cql then try to delete a component" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts.zip'), 'application/xml')

    # Make sure db is clean
    assert_equal 0, CqlMeasure.all.count

    # Sanity check
    measure = CqlMeasure.where({hqmf_set_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"}).first
    assert_nil measure

    VCR.use_cassette("valid_vsac_response_composite") do
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

    measure = CqlMeasure.where({composite: true}).first
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']
    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CqlMeasure.all.count

    # Get a component measure
    component = CqlMeasure.where({component: true}).first
    post :destroy, {
      id: component.id
    }
    assert_response :bad_request
    # Make sure nothing got deleted
    assert_equal 8, CqlMeasure.all.count
  end

  test "upload composite cql then update it" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'CMSAWA_v5_6_Artifacts.zip'), 'application/xml')

    # Make sure db is clean
    assert_equal 0, CqlMeasure.all.count

    # Sanity check
    measure = CqlMeasure.where({hqmf_set_id: "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"}).first
    assert_nil measure

    VCR.use_cassette("valid_vsac_response_composite") do
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

    measure = CqlMeasure.where({composite: true}).first
    id = measure['id']
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']
    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CqlMeasure.all.count

    # Reupload the measure
    VCR.use_cassette("valid_vsac_response_composite") do
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
    measure = CqlMeasure.where({composite: true}).first
    assert_equal "40280582-6621-2797-0166-4034035B100A", measure['hqmf_id']

    # Proves that the composite measure has actually been updated
    assert_not_equal id, measure['id']

    # This composite measure has 7 components and 1 composite measure
    assert_equal 8, CqlMeasure.all.count
  end
end
