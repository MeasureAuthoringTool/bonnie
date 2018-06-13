require 'test_helper'
require 'vcr_setup.rb'

class MeasuresControllerTest < ActionController::TestCase
include Devise::Test::ControllerHelpers

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

  test "upload CQL with valid VSAC creds" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette("valid_vsac_response") do
      measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'IETCQL_v5_0_Artifacts.zip'), 'application/xml')

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

      assert_response :redirect
      measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
      assert_equal "40280582-5859-673B-0158-DAEF8B750647", measure['hqmf_id']
    end
  end

  test "upload CQL using measure_defined and valid VSAC creds" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette("profile_query") do
      measure = CqlMeasure.where({hqmf_set_id: "442F4F7E-3C22-4641-9BEE-0E968CC38EF2"}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'DocofMeds_v5_1_Artifacts.zip'), 'application/xml')

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

      assert_response :redirect
      measure = CqlMeasure.where({hqmf_set_id: "442F4F7E-3C22-4641-9BEE-0E968CC38EF2"}).first
      assert_equal "40280582-5859-673B-0158-E42103C30732", measure['hqmf_id']
    end
  end

  test "upload CQL using release and valid VSAC creds" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette("release_query") do
      measure = CqlMeasure.where({hqmf_set_id: "442F4F7E-3C22-4641-9BEE-0E968CC38EF2"}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'DocofMeds_v5_1_Artifacts.zip'), 'application/xml')

      post :create, {
        vsac_query_type: 'release',
        vsac_query_program: 'CMS eCQM',
        vsac_query_release: 'eCQM Update 2018 EP-EC and EH',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      measure = CqlMeasure.where({hqmf_set_id: "442F4F7E-3C22-4641-9BEE-0E968CC38EF2"}).first
      assert_equal "40280582-5859-673B-0158-E42103C30732", measure['hqmf_id']
    end
  end

  test "upload CQL using profile, draft, and valid VSAC creds" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette("profile_draft_query") do
      measure = CqlMeasure.where({hqmf_set_id: "442F4F7E-3C22-4641-9BEE-0E968CC38EF2"}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'DocofMeds_v5_1_Artifacts.zip'), 'application/xml')

      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_query_measure_defined: 'false',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      measure = CqlMeasure.where({hqmf_set_id: "442F4F7E-3C22-4641-9BEE-0E968CC38EF2"}).first
      assert_equal "40280582-5859-673B-0158-E42103C30732", measure['hqmf_id']
    end
  end

  test "attempt to upload QDM measure" do
    VCR.use_cassette("valid_vsac_response") do
      measure = Measure.where({hqmf_set_id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}).first
      assert_nil measure
      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('testplan', 'DischargedOnAntithrombotic_eMeasure_Errored.xml'), 'application/xml')
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      assert_equal "Error Loading Measure", flash[:error][:title]
      assert_equal "Incorrect Upload Format.", flash[:error][:summary]
      assert_equal 'The file you have uploaded does not appear to be a Measure Authoring Tool (MAT) zip export of a measure. Please re-package and re-export your measure from the MAT.<br/>If this is a QDM-Logic Based measure, please use <a href="https://bonnie-prior.healthit.gov">Bonnie-Prior</a>.', flash[:error][:body]
    end
  end

  test "upload MAT with invalid VSAC creds" do

    # This cassette represents an exchange with the VSAC authentication server that
    # results in an unauthorized response. This cassette is used in measures_controller_test.rb
    VCR.use_cassette("invalid_vsac_response") do

      # Ensure measure is not loaded to begin with
      measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
      assert_nil measure

      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'IETCQL_v5_0_Artifacts.zip'), 'application/xml')
      # Post is sent with fake VSAC creds
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_username: 'invaliduser', vsac_password: 'invalidpassword',
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      assert_equal "Error Loading VSAC Value Sets", flash[:error][:title]
      assert_equal "VSAC credentials were invalid.", flash[:error][:summary]
      assert flash[:error][:body].starts_with?("Please verify that you are using the correct VSAC username and password.")

    end
  end

  test "upload MAT with no VSAC creds or ticket_granting_ticket in session" do
    # Ensure measure is not loaded to begin with
    measure = CqlMeasure.where({hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"}).first
    assert_nil measure
    session[:vsac_tgt] = nil

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'Test134_v5_4_Artifacts.zip'), 'application/xml')
    # Post is sent with no VSAC creds
    post :create, {
      vsac_query_type: 'profile',
      vsac_query_profile: 'Latest eCQM',
      vsac_query_include_draft: 'true',
      measure_file: measure_file,
      measure_type: 'ep',
      calculation_type: 'patient'
    }

    assert_response :redirect
    assert_equal "Error Loading VSAC Value Sets", flash[:error][:title]
    assert_equal "VSAC session expired.", flash[:error][:summary]
    assert flash[:error][:body].starts_with?("Please re-enter VSAC username and password to try again.")
  end

  test "upload MAT with that cause value sets not found error" do
    VCR.use_cassette("vsac_not_found") do
      # Ensure measure is not loaded to begin with
      measure = CqlMeasure.where({hqmf_set_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747"}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'Test134_v5_4_Artifacts.zip'), 'application/xml')

      # As of 4/18/18 the 'eCQM Update 2018-05-04' release will cause 404 for 2.16.840.1.113762.1.4.1
      post :create, {
        vsac_query_type: 'release',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_release: 'eCQM Update 2018-05-04',
        vsac_query_measure_defined: 'false',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      assert_equal "Error Loading VSAC Value Sets", flash[:error][:title]
      assert_equal "VSAC value set (2.16.840.1.113762.1.4.1) not found or is empty.", flash[:error][:summary]
      assert flash[:error][:body].starts_with?("Please verify that you are using the correct profile or release and have VSAC authoring permissions if you are requesting draft value sets.")
    end
  end

  test "upload MAT with that cause value sets 500 error" do
    # Note, do not re-record this because it is a synthetic casette that is hard to reproduce
    VCR.use_cassette("vsac_500_response") do
      # Ensure measure is not loaded to begin with
      measure = CqlMeasure.where({hqmf_set_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747"}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'Test134_v5_4_Artifacts.zip'), 'application/xml')

      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_query_measure_defined: 'false',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }

      assert_response :redirect
      assert_equal "Error Loading VSAC Value Sets", flash[:error][:title]
      assert_equal "VSAC value sets could not be loaded.", flash[:error][:summary]
      assert flash[:error][:body].ends_with?("This may be due to lack of VSAC authoring permissions if you are requesting draft value sets. Please confirm you have the appropriate authoring permissions.")
    end
  end

  test "upload MAT 5.4 with valid VSAC creds" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette("mat_5_4_valid_vsac_response") do
      measure = CqlMeasure.where({hqmf_set_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747"}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'Test134_v5_4_Artifacts.zip'), 'application/xml')

      # If you need to re-record the cassette for whatever reason, change the vsac_date to the current date
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

      assert_response :redirect
      measure = CqlMeasure.where({hqmf_set_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747"}).first
      assert_equal "40280582-5C27-8179-015C-308B1F99003B", measure['hqmf_id']
    end
  end

  test "measure show" do
    get :show, {id: @measure.id, format: :json}
    assert_response :success
    measure = JSON.parse(response.body)
    assert_equal @measure.id, measure['id']
    assert_equal @measure.title, measure['title']
    assert_equal @measure.hqmf_id, measure['hqmf_id']
    assert_equal @measure.hqmf_set_id, measure['hqmf_set_id']
    assert_equal @measure.cms_id, measure['cms_id']
    assert_nil measure['map_fns']
    assert_nil measure['record_ids']
    assert_nil measure['measure_attributes']
  end

  test "measure show with period or special chars in key" do
    VCR.use_cassette("valid_vsac_response_Test169") do
      measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'CMS169_v5_4_Artifacts_with_special_chars.zip'), 'application/xml')
      assert_not_nil measure_file
      class << measure_file
        attr_reader :tempfile
      end

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

      assert_response :redirect
      measure = CqlMeasure.where({hqmf_id: "40280582-5801-9EE4-0158-5420363B0639"}).first
      assert_not_nil measure

      # Test that ., ^, ^p, ^c behave properly
      get :show, {id: measure.id.to_str, format: :json}
      assert_response :success
      measure_res = JSON.parse(response.body)
      assert_equal measure.cql_statement_dependencies['Qualifying.Encounters^^p^c'], measure_res['cql_statement_dependencies']['Qualifying.Encounters^^p^c']
    end
  end

  test "measure destroy" do
    m2 = @measure.dup
    m2.hqmf_id = 'xxx123'
    m2.hqmf_set_id = 'yyy123'
    m2.save!
    assert_equal 4, Measure.all.count
    delete :destroy, {id: m2.id}
    assert_response :success
    assert_equal 3, Measure.all.count
  end

  test "measure value sets" do
    sign_in @user
    measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'IETCQL_v5_0_Artifacts.zip'), 'application/xml')
    class << measure_file
      attr_reader :tempfile
    end

    measure = nil
    VCR.use_cassette("valid_vsac_response") do
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
    measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first

    get :value_sets, {id: measure.id, format: :json}
    assert_response :success
    assert_equal 15, JSON.parse(response.body).keys.count
  end

  test "upload invalid file format" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_invalid_extension.foo'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_equal "Error Loading Measure", flash[:error][:title]
    assert_equal "Incorrect Upload Format.", flash[:error][:summary]
    assert_equal 'The file you have uploaded does not appear to be a Measure Authoring Tool (MAT) zip export of a measure. Please re-package and re-export your measure from the MAT.<br/>If this is a QDM-Logic Based measure, please use <a href="https://bonnie-prior.healthit.gov">Bonnie-Prior</a>.', flash[:error][:body]
    assert_response :redirect
  end

  test "upload invalid MAT zip" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_bad_MAT_export.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_equal "Error Uploading Measure", flash[:error][:title]
    assert_equal "The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.", flash[:error][:summary]
    assert_equal 'Please re-package and re-export your measure from the MAT.<br/>If this is a QDM-Logic Based measure, please use <a href="https://bonnie-prior.healthit.gov">Bonnie-Prior</a>.', flash[:error][:body]
    assert_response :redirect
  end


  test "measure clear cached javascript" do
    tmp_fns = @measure.map_fns
    @measure.map_fns = ['foo']
    @measure.save!
    @measure.reload
    assert_equal 3, @measure.map_fns[0].length
    request.env["HTTP_REFERER"] = 'http://localhost/'
    get :clear_cached_javascript, {id: @measure.id}
    assert_response :redirect
    @measure.reload
    assert_operator Measure.all.first.map_fns[0].length, :>, 100
  end

  test "load QDM xml" do

    # fails to load QDM measure
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_bad_hqmf.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect

    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first

    assert_nil measure
    assert_includes flash[:error].keys, :title
    assert_includes flash[:error].keys, :summary
    assert_equal 'The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.', flash[:error][:summary]
    assert_equal 'Please re-package and re-export your measure from the MAT.<br/>If this is a QDM-Logic Based measure, please use <a href="https://bonnie-prior.healthit.gov">Bonnie-Prior</a>.', flash[:error][:body]
    flash.clear
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    assert_nil measure
    assert_equal 0, Dir.glob(File.join(@error_dir, '**')).count
  end

  test "load with no zip" do
    post :create, {measure_file: nil, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect

    assert_includes flash[:error].keys, :title
    assert_includes flash[:error].keys, :body
    assert_equal 'You must specify a Measure Authoring tool measure export to use.', flash[:error][:body]
    flash.clear
  end

  test "upload measure already loaded" do
    measure = nil
    # Use the valid vsac response recording each time attempting to upload measure
    VCR.use_cassette("valid_vsac_response") do
      sign_in @user
      measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'IETCQL_v5_0_Artifacts.zip'), 'application/xml')
      class << measure_file
        attr_reader :tempfile
      end

      # Assert measure is not yet loaded
      measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first
      assert_nil measure
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
      assert_response :redirect
      measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first
      assert_not_nil measure
    end
    update_measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'IETCQL_v5_0_Artifacts.zip'), 'application/xml')
    # Now measure successfully uploaded, try to upload again
    post :create, {
      vsac_query_type: 'profile',
      vsac_query_profile: 'Latest eCQM',
      vsac_query_include_draft: 'false',
      vsac_query_measure_defined: 'true',
      vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
      measure_file: update_measure_file,
      measure_type: 'ep',
      calculation_type: 'patient'
    }

    assert_equal "Error Loading Measure", flash[:error][:title]
    assert_equal "A version of this measure is already loaded.", flash[:error][:summary]
    assert_equal "You have a version of this measure loaded already.  Either update that measure with the update button, or delete that measure and re-upload it.", flash[:error][:body]
    assert_response :redirect

    # Verify measure has not been deleted or modified
    measure_after = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first
    assert_equal measure, measure_after

  end

  test "update with hqmf set id mismatch" do
    # Upload the initial file
    VCR.use_cassette("valid_vsac_response") do
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'IETCQL_v5_0_Artifacts.zip'), 'application/xml')
      class << measure_file
        attr_reader :tempfile
      end
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
    # Upload a modified version of the initial file with a mismatching hqmf_set_id
    update_measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'IETCQL_v5_0_Artifacts_HQMF_SetId_Mismatch.zip'), 'application/xml')
    class << update_measure_file
      attr_reader :tempfile2
    end
    # The hqmf_set_id of the initial file is sent along with the create request
    post :create, {
      vsac_query_type: 'profile',
      vsac_query_profile: 'Latest eCQM',
      vsac_query_include_draft: 'false',
      vsac_query_measure_defined: 'true',
      vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
      measure_file: update_measure_file,
      hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"
    }

    # Verify that the controller detects the mismatching hqmf_set_id and rejects
    assert_equal "Error Updating Measure", flash[:error][:title]
    assert_equal "The update file does not match the measure.", flash[:error][:summary]
    assert_equal "You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure.", flash[:error][:body]
    assert_response :redirect

    # Verify that the initial file remained unchanged
    measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first
    assert_equal "762B1B52-40BF-4596-B34F-4963188E7FF7", measure.hqmf_set_id
  end

  test "upload missing value set missing oid" do
    # in the CQL file, the 'Alcohol and Drug Dependence Treatment' value set oid was changed from
    # '2.16.840.1.113883.3.464.1003.106.12.1005' to '2.16.840.1.113883.3.464.1003.106.12.1001'.
    # no changes in the HQMF.
    sign_in @user
    measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'IETCQL_v5_0_missing_vs_oid_Artifacts.zip'), 'application/xml')
    class << measure_file
      attr_reader :tempfile
    end

    measure = nil
    VCR.use_cassette("missing_vs_oid_response") do
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

    assert_equal "Measure is missing value sets",flash[:error][:title]
    assert_equal "The measure you have tried to load is missing value sets.", flash[:error][:summary]
    assert_equal "The measure you are trying to load is missing value sets.  Try re-packaging and re-exporting the measure from the Measure Authoring Tool.  The following value sets are missing: [2.16.840.1.113883.3.464.1003.106.12.1005]", flash[:error][:body]

  end

  test "create/finalize/update a measure" do
    sign_in @user
    measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'IETCQL_v5_0_initial_Artifacts.zip'), 'application/xml')
    class << measure_file
      attr_reader :tempfile
    end
    update_measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'IETCQL_v5_0_updates_Artifacts.zip'), 'application/xml')
    class << update_measure_file
      attr_reader :tempfile
    end

    measure = nil
    # associate a patient with the measure about to be created so the patient will be rebuilt
    p = Record.by_user(@user).first
    p.measure_ids = ["762B1B52-40BF-4596-B34F-4963188E7FF7"]
    p.save

    VCR.use_cassette("initial_response") do
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

    assert_response :redirect
    measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first

    assert_equal "762B1B52-40BF-4596-B34F-4963188E7FF7", measure.hqmf_set_id
    assert_equal 15, measure.value_sets.count
    assert_equal @user.id, measure.user_id
    measure.value_sets.each {|vs| assert_equal @user.id, vs.user_id}
    assert_equal true, measure.needs_finalize
    assert_equal true, measure.episode_of_care?
    assert_equal 'eh', measure.type
    assert_nil measure.episode_ids
    assert_nil measure.hybrid

    assert_equal 1, (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.464.1003.106.12.1001'}).count
    assert_equal 745, (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.464.1003.106.12.1001' && vs.version == "MU2 Update 2017-01-06"}).first.concepts.count

    # Finalize the measure that was just created
    post :finalize, {"t679"=>{"hqmf_id"=>"40280582-5859-673B-0158-DAEF8B750647"}}
    measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first

    assert_equal "762B1B52-40BF-4596-B34F-4963188E7FF7", measure.hqmf_set_id
    assert_equal 15, measure.value_sets.count
    assert_equal @user.id, measure.user_id
    measure.value_sets.each {|vs| assert_equal @user.id, vs.user_id}
    assert_equal false, measure.needs_finalize
    assert_equal true, measure.episode_of_care?
    assert_equal 'eh', measure.type
    assert_nil measure.episode_ids
    measure_id_before = measure._id

    # Update the measure
    VCR.use_cassette("update_response") do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: update_measure_file,
        measure_type: 'eh',
        calculation_type: 'episode',
        hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"
      }
    end

    assert_response :redirect
    measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first
    assert_not_equal measure_id_before, measure._id

    assert_equal "762B1B52-40BF-4596-B34F-4963188E7FF7", measure.hqmf_set_id
    assert_equal 26, measure.value_sets.count # new entries for VSs with new versions, which is 11 of them
    assert_equal @user.id, measure.user_id
    measure.value_sets.each {|vs| assert_equal @user.id, vs.user_id}
    assert_equal false, measure.needs_finalize
    assert_equal true, measure.episode_of_care?
    assert_equal 'eh', measure.type
    assert_nil measure.episode_ids
    assert_nil measure.hybrid

    assert_equal 2, (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.464.1003.106.12.1001'}).count
    assert_equal 745, (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.464.1003.106.12.1001' && vs.version == "MU2 Update 2017-01-06"}).first.concepts.count
    assert_equal 516, (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.464.1003.106.12.1001' && vs.version == "eCQM Update 2017-05-05"}).first.concepts.count
  end

  test "load HQMF bad xml" do
    sign_in @user
    measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'IETCQL_v5_0_bad_hqmf_Artifacts.zip'), 'application/xml')
    class << measure_file
      attr_reader :tempfile
    end

    measure = nil
    VCR.use_cassette("valid_vsac_response") do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'ep',
        calculation_type: 'patient'
      }
    end

    assert_response :redirect
    measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first

    assert_nil measure
    assert_includes flash[:error].keys, :title
    assert_includes flash[:error].keys, :summary
    assert_includes flash[:error].keys, :body
    assert_equal 'The measure could not be loaded.', flash[:error][:summary]
    flash.clear

    assert_equal 2, Dir.glob(File.join(@error_dir, '**')).count
    assert_equal true, FileUtils.identical?(File.join(@error_dir, (Dir.entries(@error_dir).select { |f| f.end_with?('.xmlorzip') })[0]), File.join('test', 'fixtures', 'cql_measure_exports', 'IETCQL_v5_0_bad_hqmf_Artifacts.zip'))
  end

  test "update a patient based measure" do
    sign_in @user
    measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'IETCQL_v5_0_Artifacts.zip'), 'application/xml')
    class << measure_file
      attr_reader :tempfile
    end

    measure = nil
    VCR.use_cassette("valid_vsac_response") do
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
    measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first
    assert_equal "762B1B52-40BF-4596-B34F-4963188E7FF7", measure.hqmf_set_id

    assert_equal false, measure.episode_of_care?
    assert_equal 'ep', measure.type

    VCR.use_cassette("valid_vsac_response") do
      post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: 'Latest eCQM',
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        measure_file: measure_file,
        hqmf_set_id: measure.hqmf_set_id
      }
    end

    assert_response :redirect
    measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first
    assert_equal "762B1B52-40BF-4596-B34F-4963188E7FF7", measure.hqmf_set_id

    assert_equal false, measure.episode_of_care?
    assert_equal 'ep', measure.type
  end

  test "create/finalize/update a hybrid measure" do
  sign_in @user
  measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'IETCQL_v5_0_initial_Artifacts.zip'), 'application/xml')
  class << measure_file
    attr_reader :tempfile
  end
  update_measure_file = fixture_file_upload(File.join('test','fixtures', 'cql_measure_exports', 'IETCQL_v5_0_updates_Artifacts.zip'), 'application/xml')
  class << update_measure_file
    attr_reader :tempfile
  end

  measure = nil
  # associate a patient with the measure about to be created so the patient will be rebuilt
  p = Record.by_user(@user).first
  p.measure_ids = ["762B1B52-40BF-4596-B34F-4963188E7FF7"]
  p.save

  VCR.use_cassette("initial_response_hybrid") do
    post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: APP_CONFIG['vsac']['default_profile'],
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: measure_file,
        measure_type: 'eh',
        calculation_type: 'episode',
        hybrid_measure: 'true'
    }
  end

  measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first
  assert_equal true, measure.hybrid
  assert_equal true, measure.episode_of_care?
  assert_equal 'eh', measure.type

  # Update the measure
  VCR.use_cassette("update_response_hybrid") do
    post :create, {
        vsac_query_type: 'profile',
        vsac_query_profile: APP_CONFIG['vsac']['default_profile'],
        vsac_query_include_draft: 'false',
        vsac_query_measure_defined: 'true',
        vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
        measure_file: update_measure_file,
        hqmf_set_id: "762B1B52-40BF-4596-B34F-4963188E7FF7"
    }
  end

  measure = CqlMeasure.where({hqmf_id: "40280582-5859-673B-0158-DAEF8B750647"}).first
  assert_equal true, measure.hybrid
  assert_equal true, measure.episode_of_care?
  assert_equal 'eh', measure.type

end

end
