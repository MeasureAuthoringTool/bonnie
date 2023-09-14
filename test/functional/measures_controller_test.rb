require 'test_helper'
require 'vcr_setup'

class MeasuresControllerTest < ActionController::TestCase
include Devise::Test::ControllerHelpers

  setup do
    APP_CONFIG['virus_scan']['enabled'] = false

    @error_dir = File.join('log', 'load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    users_set = File.join('users', 'base_set')
    patients_set = File.join('cqm_patients', 'CMS903v0')
    strat_measure_patients_set = File.join('cqm_patients',  'CMSv0')
    load_measure_fixtures_from_folder(File.join('measures', 'CMS160v6'), @user)
    collection_fixtures(users_set, patients_set, strat_measure_patients_set)
    @user = User.by_email('bonnie@example.com').first
    @user.init_personal_group
    @user.save
    associate_user_with_patients(@user, CQM::Patient.all)
    sign_in @user

    @vcr_options = {match_requests_on: [:method, :uri_no_st]}
  end

  def teardown
    APP_CONFIG['virus_scan']['enabled'] = false
  end

  test 'test virus scanner 500' do
    APP_CONFIG['virus_scan']['enabled'] = true
    VCR.use_cassette("upload_measure_virus_500") do
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS158v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/zip')
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
      assert_not_nil flash
      assert_equal 'Error Loading Measure', flash[:error][:title]
      assert_equal 'The measure could not be loaded.', flash[:error][:summary]
      assert_equal 'Error: V101. Bonnie has encountered an error while trying to load the measure.', flash[:error][:body]
      assert_response :redirect
    end
  end

  test 'test virus scanner 200 infected:false' do
    APP_CONFIG['virus_scan']['enabled'] = true
    VCR.use_cassette("upload_measure_virus_200_infected_false", @vcr_options) do
      measure = CQM::Measure.where({hqmf_set_id: '3BBFC929-50C8-44B8-8D34-82BE75C08A70'}).first
      assert_nil measure

      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS158v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/zip')
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
      assert_response :redirect

      measure = CQM::Measure.where({hqmf_set_id: '3BBFC929-50C8-44B8-8D34-82BE75C08A70'}).first
      assert_equal '40280382-5FA6-FE85-015F-B5969D1D0264', measure['hqmf_id']

      # delete measure
      delete :destroy, params: { id: measure.id.to_s }
      measure = CQM::Measure.where({set_id: '40280382-5FA6-FE85-015F-B5969D1D0264'}).first
      assert_nil measure
    end
  end

  test 'test virus scanner 200 infected:true' do
    APP_CONFIG['virus_scan']['enabled'] = true
    VCR.use_cassette("upload_measure_virus_200_infected_true") do
      measure = CQM::Measure.where({hqmf_set_id: '3BBFC929-50C8-44B8-8D34-82BE75C08A70'}).first
      assert_nil measure

      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS158v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/zip')
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
      assert_not_nil flash
      assert_equal 'Error Loading Measure', flash[:error][:title]
      assert_equal 'The uploaded file is not a valid Measure Authoring Tool (MAT) export of a QDM Based Measure.', flash[:error][:summary]
      assert_equal 'Error: V100. Please re-package and re-export your QDM based measure from the MAT and try again.', flash[:error][:body]
      assert_response :redirect
    end
  end

  test 'upload CQL with valid VSAC creds' do
    # This cassette uses the ENV[VSAC_API_KEY] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette('valid_vsac_response', @vcr_options) do
      measure = CQM::Measure.where({hqmf_set_id: '3BBFC929-50C8-44B8-8D34-82BE75C08A70'}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS158v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/zip')

      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect

      measure = CQM::Measure.where({hqmf_set_id: '3BBFC929-50C8-44B8-8D34-82BE75C08A70'}).first
      assert_equal '40280382-5FA6-FE85-015F-B5969D1D0264', measure['hqmf_id']
    end
  end

  test 'upload CQL using measure_defined and valid VSAC creds' do
    # This cassette uses the ENV['VSAC_API_KEY'] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette('profile_query', @vcr_options) do
      measure = CQM::Measure.where({hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076'}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cqm_measure_exports', 'CMS903v0.zip'), 'application/zip')

      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      measure = CQM::Measure.where({hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076'}).first
      assert_equal '40280382667FECC30167190FAE723AAE', measure['hqmf_id']
    end
  end

  test 'upload CQL using release and valid VSAC creds' do
    # This cassette uses the ENV['VSAC_API_KEY'] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette('release_query', @vcr_options) do
      measure = CQM::Measure.where({hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076'}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cqm_measure_exports', 'CMS903v0.zip'), 'application/zip')

      post :create, params: {
        vsac_query_type: 'release',
        vsac_query_program: 'CMS eCQM',
        vsac_query_release: 'eCQM Update 2018 EP-EC and EH',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      measure = CQM::Measure.where({hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076'}).first
      assert_equal '40280382667FECC30167190FAE723AAE', measure['hqmf_id']
    end
  end

  test 'upload CQL using profile, draft, and valid VSAC creds' do
    # This cassette uses the ENV['VSAC_API_KEY'] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette('profile_draft_query', @vcr_options) do
      measure = CQM::Measure.where({hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076'}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cqm_measure_exports', 'CMS903v0.zip'), 'application/zip')

      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_query_measure_defined: 'false',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      measure = CQM::Measure.where({hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076'}).first
      assert_equal '40280382667FECC30167190FAE723AAE', measure['hqmf_id']
    end
  end

  test 'attempt to upload QDM measure' do
    VCR.use_cassette('valid_vsac_response', @vcr_options) do
      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('testplan', 'DischargedOnAntithrombotic_eMeasure_Errored.xml'), 'application/xml')
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      assert_equal 'Error Uploading Measure', flash[:error][:title]
      assert_equal 'The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.', flash[:error][:summary]
      assert_equal "Measure loading process encountered error: Error processing package file: Zip end of central directory signature not found Please re-package and re-export your measure from the MAT.<br/>", flash[:error][:body]
    end
  end

  test 'upload MAT with invalid VSAC creds' do
    # This cassette represents an exchange with VSAC that results in an unauthorized response.
    # This cassette is used in measures_controller_test.rb
    VCR.use_cassette('invalid_vsac_response', @vcr_options) do

      # Ensure measure is not loaded to begin with
      measure = CQM::Measure.where({hqmf_set_id: '3BBFC929-50C8-44B8-8D34-82BE75C08A70'}).first
      assert_nil measure

      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS158v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/zip')
      # Post is sent with fake VSAC creds
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_api_key: 'badkey',
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      assert_equal 'Error Loading VSAC Value Sets', flash[:error][:title]
      assert_equal 'VSAC credentials were invalid.', flash[:error][:summary]
      assert flash[:error][:body].starts_with?('Please verify that you are using your valid VSAC API Key.')

    end
  end

  test 'upload MAT with unsupported Related Person QDM data element' do
    # This cassette represents an exchange with the VSAC authentication server that
    # results in an unauthorized response. This cassette is used in measures_controller_test.rb
    VCR.use_cassette('unsupported_QDM_data_element', @vcr_options) do

      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cqm_measure_exports', 'EBMF_v5_8_Artifacts.zip'), 'application/zip')
      # Post is sent with fake VSAC creds
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      assert_equal 'Error Loading Measure', flash[:error][:title]
      assert_equal 'Unsupported Data Element Used In Measure.', flash[:error][:summary]
      assert_equal 'Bonnie does not support the Related Person QDM Data Element used in this measure.', flash[:error][:body]

    end
  end

  test 'upload MAT with no VSAC creds in session' do
    # Ensure measure is not loaded to begin with
    measure = CQM::Measure.where({hqmf_set_id: '762B1B52-40BF-4596-B34F-4963188E7FF7'}).first
    assert_nil measure
    session[:vsac_tgt] = nil

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'Test134_v5_4_Artifacts.zip'), 'application/zip')
    # Post is sent with no VSAC creds
    post :create, params: {
      vsac_query_type: 'profile',
      vsac_query_profile: 'Latest eCQM',
      vsac_query_include_draft: 'true',
      measure_file: measure_file,
      measure_type: 'ep',
      calculation_type: 'patient'
    }

    assert_response :redirect
    assert_equal 'Error Loading VSAC Value Sets', flash[:error][:title]
    assert_equal 'No VSAC credentials provided.', flash[:error][:summary]
    assert flash[:error][:body].starts_with?('Please re-enter VSAC API Key to try again.')
  end

  test 'upload MAT with that cause value sets not found error' do
    VCR.use_cassette('vsac_not_found', @vcr_options) do
      # Ensure measure is not loaded to begin with
      measure = CQM::Measure.where({hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076'}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cqm_measure_exports', 'CMS903v0.zip'), 'application/zip')

      post :create, params: {
        vsac_query_type: 'release',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_release: 'Fake 1234',
        vsac_query_measure_defined: 'false',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      assert_equal 'Error Loading VSAC Value Sets', flash[:error][:title]
      assert_equal 'VSAC value set (2.16.840.1.113883.3.117.1.7.1.87) not found or is empty.', flash[:error][:summary]
      assert flash[:error][:body].starts_with?('Please verify that you are using the correct profile or release and have VSAC authoring permissions if you are requesting draft value sets.')
    end
  end


  # UNABLE TO GET WORKING
  test 'upload MAT with that cause value sets 500 error' do
    VCR.use_cassette('vsac_500_response', @vcr_options) do
      # Ensure measure is not loaded to begin with
      measure = CQM::Measure.where({hqmf_set_id: '7B2A9277-43DA-4D99-9BEE-6AC271A07747'}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'special_measures', 'Authoring_Permissions_Needed.zip'), 'application/zip')

      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_query_measure_defined: 'false',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      assert_equal 'Error Loading VSAC Value Sets', flash[:error][:title]
      assert_equal 'VSAC value sets could not be loaded.', flash[:error][:summary]
      assert flash[:error][:body].ends_with?('This may be due to lack of VSAC authoring permissions if you are requesting draft value sets. Please confirm you have the appropriate authoring permissions.')
    end
  end

  test 'upload MAT 5.4 with valid VSAC creds' do
    # This cassette uses the ENV[VSAC_API_KEY] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette('mat_5_4_valid_vsac_response', @vcr_options) do
      measure = CQM::Measure.where({hqmf_set_id: '7B2A9277-43DA-4D99-9BEE-6AC271A07747'}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'Test134_v5_4_Artifacts.zip'), 'application/zip')

      # If you need to re-record the cassette for whatever reason, change the vsac_date to the current date
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      measure = CQM::Measure.where({hqmf_set_id: '7B2A9277-43DA-4D99-9BEE-6AC271A07747'}).first
      assert_equal '40280582-5C27-8179-015C-308B1F99003B', measure['hqmf_id']
    end
  end

  test 'measure show' do
    VCR.use_cassette('measure_show', @vcr_options) do
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'Test134_v5_4_Artifacts.zip'), 'application/zip')

      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
      measure = CQM::Measure.where({hqmf_set_id: '7B2A9277-43DA-4D99-9BEE-6AC271A07747'}).first

      get :show, params: {id: measure.id}, as: :json
      assert_response :success
      shown = JSON.parse(response.body)
      assert_equal measure._id.to_s, shown['_id']
      assert_equal measure.title, shown['title']
      assert_equal measure.hqmf_id, shown['hqmf_id']
      assert_equal measure.hqmf_set_id, shown['hqmf_set_id']
      assert_equal measure.cms_id, shown['cms_id']
      assert_nil shown['record_ids']
      assert_nil shown['measure_attributes']
    end
  end

  test 'measure works with period in statement name' do
    VCR.use_cassette('valid_vsac_response_Test169', @vcr_options) do
      measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'deprecated_measures', 'CMS169_v5_4_Artifacts_with_period.zip'), 'application/zip')
      assert_not_nil measure_file
      class << measure_file
        attr_reader :tempfile
      end

      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      measure = CQM::Measure.where({hqmf_id: '40280582-5801-9EE4-0158-5420363B0639'}).first
      assert_not_nil measure

      # Test that . behaves properly
      get :show, params: {id: measure.id.to_str}, as: :json
      assert_response :success
      measure_res = JSON.parse(response.body)
      orig = measure.cql_libraries[0].statement_dependencies.select {|sd| sd.statement_name == 'Qualifying.Encounters'}[0].statement_name
      shown = measure_res['cql_libraries'][0]['statement_dependencies'].select {|sd| sd['statement_name'] == 'Qualifying.Encounters'}[0]['statement_name']
      assert_equal orig, shown
    end
  end

  test 'measure destroy' do
    VCR.use_cassette('measure_destroy', @vcr_options) do
      measure_file1 = fixture_file_upload(File.join('test', 'fixtures', 'cqm_measure_exports', 'CMS903v0.zip'), 'application/zip')

      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file1,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_equal 2, CQM::Measure.count
      assert_equal 2, CQM::MeasurePackage.count
      assert_equal 26, CQM::ValueSet.count

      delete :destroy, params: {id: CQM::Measure.where({cms_id: 'CMS903v0'}).first.id}
      assert_response :success

      assert_equal 1, CQM::Measure.count
      assert_equal 1, CQM::MeasurePackage.count
      assert_equal 16, CQM::ValueSet.count
    end
  end

  test 'upload invalid file format' do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'deprecated_measures', 'measure_invalid_extension.foo'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    # give it a fake VSAC ticket to get through the check for one
    session[:vsac_tgt] = { ticket: 'fake ticket', expires: DateTime.now + 60.minutes }
    post :create, params: {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_equal 'Error Uploading Measure', flash[:error][:title]
    assert_equal 'The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.', flash[:error][:summary]
    assert_equal "Measure loading process encountered error: Error processing package file: Zip end of central directory signature not found Please re-package and re-export your measure from the MAT.<br/>", flash[:error][:body]
    assert_response :redirect
  end

  test 'upload invalid MAT zip' do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'deprecated_measures', 'measure_bad_MAT_export.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    # give it a fake VSAC ticket to get through the check for one
    session[:vsac_tgt] = { ticket: 'fake ticket', expires: DateTime.now + 60.minutes }
    post :create, params: {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode', vsac_api_key: ENV['VSAC_API_KEY']}
    assert_equal 'Error Uploading Measure', flash[:error][:title]
    assert_equal 'The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.', flash[:error][:summary]
    assert_equal "Measure loading process encountered error: Error processing package file: No measure found Please re-package and re-export your measure from the MAT.<br/>", flash[:error][:body]
    assert_response :redirect
  end

  test 'load QDM xml' do
    # fails to load QDM measure
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'deprecated_measures', 'measure_bad_hqmf.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    # give it a fake VSAC ticket to get through the check for one
    session[:vsac_tgt] = { ticket: 'fake ticket', expires: DateTime.now + 60.minutes }
    post :create, params: {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect

    assert_includes flash[:error].keys, :title
    assert_includes flash[:error].keys, :summary
    assert_equal 'The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.', flash[:error][:summary]
    assert_equal "Measure loading process encountered error: Error processing package file: Measure package missing required element: CQL Libraries Please re-package and re-export your measure from the MAT.<br/>", flash[:error][:body]
    flash.clear
    assert_equal 2, Dir.glob(File.join(@error_dir, '**')).count
  end

  test 'load with no zip' do
    post :create, params: {measure_file: nil, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect

    assert_includes flash[:error].keys, :title
    assert_includes flash[:error].keys, :body
    assert_equal 'You must specify a Measure Authoring tool measure export to use.', flash[:error][:body]
    flash.clear
  end

  test 'upload measure already loaded' do
    measure = nil
    # Use the valid vsac response recording each time attempting to upload measure
    VCR.use_cassette('valid_vsac_response_reload_measure', @vcr_options) do
      sign_in @user
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS158v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/zip')
      class << measure_file
        attr_reader :tempfile
      end

      # Assert measure is not yet loaded
      measure = CQM::Measure.where({hqmf_set_id: '3BBFC929-50C8-44B8-8D34-82BE75C08A70'}).first
      assert_nil measure
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
      assert_response :redirect
      measure = CQM::Measure.where({hqmf_set_id: '3BBFC929-50C8-44B8-8D34-82BE75C08A70'}).first
      assert_not_nil measure
      update_measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS158v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/zip')
      # Now measure successfully uploaded, try to upload again
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: update_measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_equal 'Error Loading Measure', flash[:error][:title]
      assert_equal 'A version of this measure is already loaded.', flash[:error][:summary]
      assert_equal 'You have a version of this measure loaded already.  Either update that measure with the update button, or delete that measure and re-upload it.', flash[:error][:body]
      assert_response :redirect

      # Verify measure has not been deleted or modified
      measure_after = CQM::Measure.where({hqmf_set_id: '3BBFC929-50C8-44B8-8D34-82BE75C08A70'}).first
      assert_equal measure, measure_after
    end
  end

  test 'update measure doesnt affect expected values' do
    measure = nil
    # Use the valid vsac response recording each time attempting to upload measure
    VCR.use_cassette('measure_loading_does_not_alter_expected_values', @vcr_options) do
      sign_in @user
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cqm_measure_exports', 'MedianAdmitDecisionTime_v5_8_Artifacts.zip'), 'application/zip')
      class << measure_file
        attr_reader :tempfile
      end
      patient_before = CQM::Patient.where({measure_ids: ['845E4012-4A98-413B-82C6-675E1E84B385']}).first
      # Assert measure is not yet loaded
      measure = CQM::Measure.where({hqmf_set_id: '845E4012-4A98-413B-82C6-675E1E84B385'}).first
      assert_nil measure
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
      assert_response :redirect
      measure = CQM::Measure.where({hqmf_set_id: '845E4012-4A98-413B-82C6-675E1E84B385'}).first
      assert_not_nil measure
      patient_after = CQM::Patient.where({measure_ids: ['845E4012-4A98-413B-82C6-675E1E84B385']}).first
      assert_equal patient_before.expectedValues.to_s, patient_after.expectedValues.to_s

    end
  end

  test 'update with hqmf set id mismatch' do
    # Upload the initial file
    VCR.use_cassette('valid_vsac_response_hqmf_set_id_mismatch', @vcr_options) do
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cqm_measure_exports', 'CMS903v0.zip'), 'application/zip')
      class << measure_file
        attr_reader :tempfile
      end
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
      # Upload a modified version of the initial file with a mismatching hqmf_set_id
      update_measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cqm_measure_exports', 'CMS903v0_mismatch_hqmf_set_id.zip'), 'application/zip')
      class << update_measure_file
        attr_reader :tempfile2
      end
      # The hqmf_set_id of the initial file is sent along with the create request
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: update_measure_file,
        hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076'
      }

      # Verify that the controller detects the mismatching hqmf_set_id and rejects
      assert_equal 'Error Updating Measure', flash[:error][:title]
      assert_equal 'The update file does not match the measure.', flash[:error][:summary]
      assert_equal 'You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure.', flash[:error][:body]
      assert_response :redirect

      # Verify that the initial file remained unchanged
      measure = CQM::Measure.where({hqmf_id: '40280382667FECC30167190FAE723AAE'}).first
      assert_equal '4DC3E7AA-8777-4749-A1E4-37E942036076', measure.hqmf_set_id
    end
  end

  test 'create/finalize/update a measure' do
    sign_in @user
    measure_file = fixture_file_upload(File.join('test','fixtures', 'cqm_measure_exports', 'CMS903v0.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    update_measure_file = fixture_file_upload(File.join('test','fixtures', 'cqm_measure_exports', 'CMS903v999_updated_cms_id.zip'), 'application/zip')
    class << update_measure_file
      attr_reader :tempfile
    end

    measure = nil
    # associate a patient with the measure about to be created so the patient will be rebuilt
    p = CQM::Patient.by_user(@user).first
    p.measure_ids = ['4DC3E7AA-8777-4749-A1E4-37E942036076']
    p.save

    VCR.use_cassette('initial_response', @vcr_options) do
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'eh',
        calculation_type: 'episode'
      }
    end

    assert_response :redirect
    measure = CQM::Measure.where({hqmf_id: '40280382667FECC30167190FAE723AAE'}).first
    assert_equal '4DC3E7AA-8777-4749-A1E4-37E942036076', measure.hqmf_set_id
    assert_equal 10, measure.value_sets.count
    assert_equal @user.current_group.id, measure.group_id
    measure.value_sets.each {|vs| assert_equal @user.current_group.id, vs.group_id}
    assert_equal true, measure.calculation_method == 'EPISODE_OF_CARE'
    assert_nil measure.calculate_sdes

    assert_equal 1, (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113762.1.4.1'}).count
    assert_equal 3, (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113762.1.4.1111.143'}).first.concepts.count

    # Finalize the measure that was just created
    post :finalize, params: {t679: { hqmf_id: '40280382667FECC30167190FAE723AAE', titles: ['ps1','ps1strat1','ps1strat2','ps1strat3'] } }
    measure = CQM::Measure.where({hqmf_id: '40280382667FECC30167190FAE723AAE'}).first

    assert_equal 'ps1', measure.population_sets[0].title
    assert_equal 'ps1strat1', measure.population_sets[0].stratifications[0].title
    assert_equal 'ps1strat2', measure.population_sets[0].stratifications[1].title
    assert_equal 'ps1strat3', measure.population_sets[0].stratifications[2].title
    assert_equal '4DC3E7AA-8777-4749-A1E4-37E942036076', measure.hqmf_set_id
    assert_equal 10, measure.value_sets.count
    assert_equal @user.current_group.id, measure.group_id
    measure.value_sets.each {|vs| assert_equal @user.current_group.id, vs.group_id}
    assert_equal true, measure.calculation_method == 'EPISODE_OF_CARE'
    measure_id_before = measure._id

    # Update the measure
    VCR.use_cassette('update_response', @vcr_options) do
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: update_measure_file,
        measure_type: 'eh',
        calculation_type: 'episode',
        hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076'
      }
    end
    assert_response :redirect
    assert_equal 1, CQM::Measure.where({hqmf_id: '40280382667FECC30167190FAE723AAE'}).size
    measure = CQM::Measure.where({hqmf_id: '40280382667FECC30167190FAE723AAE'}).first
    assert_not_equal measure_id_before, measure._id
    assert_equal '4DC3E7AA-8777-4749-A1E4-37E942036076', measure.hqmf_set_id
    assert_equal 'CMS903v999', measure.cms_id
    assert_equal 10, measure.value_sets.count
    assert_equal @user.current_group.id, measure.group_id
    measure.value_sets.each {|vs| assert_equal @user.current_group.id, vs.group_id}
    assert_equal true, measure.calculation_method == 'EPISODE_OF_CARE'
    assert_nil measure.calculate_sdes

    assert_equal 1, (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113762.1.4.1'}).count
    assert_equal 3, (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113762.1.4.1111.143'}).first.concepts.count
  end

  test 'load HQMF bad xml' do
    sign_in @user
    measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'deprecated_measures', 'IETCQL_v5_0_bad_hqmf_Artifacts.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    measure = nil
    VCR.use_cassette('valid_vsac_response', @vcr_options) do
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
    end

    assert_response :redirect
    measure = CQM::Measure.where({hqmf_id: '40280582-5859-673B-0158-DAEF8B750647'}).first

    assert_nil measure
    assert_includes flash[:error].keys, :title
    assert_includes flash[:error].keys, :summary
    assert_includes flash[:error].keys, :body
    assert_equal 'The measure could not be loaded.', flash[:error][:summary]
    flash.clear

    assert_equal 2, Dir.glob(File.join(@error_dir, '**')).count
    assert_equal true, FileUtils.identical?(File.join(@error_dir, (Dir.entries(@error_dir).select { |f| f.end_with?('.xmlorzip') })[0]), File.join('test', 'fixtures', 'cql_measure_exports', 'deprecated_measures', 'IETCQL_v5_0_bad_hqmf_Artifacts.zip'))
  end

  test 'update a patient based measure' do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS158v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/zip')
    sign_in @user
    class << measure_file
      attr_reader :tempfile
    end

    measure = nil
    VCR.use_cassette('valid_vsac_response', @vcr_options) do
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
    end
    assert_response :redirect
    measure = CQM::Measure.where({hqmf_id: '40280382-5FA6-FE85-015F-B5969D1D0264'}).first
    assert_equal '3BBFC929-50C8-44B8-8D34-82BE75C08A70', measure.hqmf_set_id

    assert_equal false, measure.calculation_method == 'EPISODE_OF_CARE'

    VCR.use_cassette('valid_vsac_response', @vcr_options) do
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        measure_file: measure_file,
        hqmf_set_id: measure.hqmf_set_id
      }
    end

    assert_response :redirect
    measure = CQM::Measure.where({hqmf_id: '40280382-5FA6-FE85-015F-B5969D1D0264'}).first
    assert_equal '3BBFC929-50C8-44B8-8D34-82BE75C08A70', measure.hqmf_set_id

    assert_equal false, measure.calculation_method == 'EPISODE_OF_CARE'
  end

  test 'create/finalize/update a measure calculating SDEs' do
    # TODO: fix this after MAT-987 release
    skip "fix this after MAT-987 release"
    sign_in @user
    measure_file = fixture_file_upload(File.join('test','fixtures', 'cqm_measure_exports', 'CMS903v0.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    update_measure_file = fixture_file_upload(File.join('test','fixtures', 'cqm_measure_exports', 'CMS903v999_updated_cms_id.zip'), 'application/zip')
    class << update_measure_file
      attr_reader :tempfile
    end

    measure = nil
    # associate a patient with the measure about to be created so the patient will be rebuilt
    p = CQM::Patient.by_user(@user).first
    p.measure_ids = ['4DC3E7AA-8777-4749-A1E4-37E942036076']
    p.save

    VCR.use_cassette('initial_response_calc_SDEs', @vcr_options) do
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: measure_file,
        measure_type: 'eh',
        calculation_type: 'episode',
        calc_sde: 'true'
      }
    end
    measure = CQM::Measure.where({hqmf_id: '40280382667FECC30167190FAE723AAE'}).first
    assert_equal true, measure.calculate_sdes
    assert_equal true, measure.calculation_method == 'EPISODE_OF_CARE'

    # Update the measure
    VCR.use_cassette('update_response_calc_SDEs', @vcr_options) do
      post :create, params: {
        vsac_query_type: 'profile',
        vsac_query_profile: APP_CONFIG['vsac']['default_profile'],
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_api_key: ENV['VSAC_API_KEY'],
        measure_file: update_measure_file,
        hqmf_set_id: '4DC3E7AA-8777-4749-A1E4-37E942036076'
      }
    end

    measure = CQM::Measure.where({hqmf_id: '40280382667FECC30167190FAE723AAE'}).first
    assert_equal true, measure.calculate_sdes
    assert_equal 'CMS903v999', measure.cms_id
    assert_equal true, measure.calculation_method == 'EPISODE_OF_CARE'
  end
end
