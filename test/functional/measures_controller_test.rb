require 'test_helper'
require 'vcr_setup.rb'

class MeasuresControllerTest  < ActionController::TestCase
include Devise::TestHelpers

  setup do
    @error_dir = File.join('log', 'load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    users_set = File.join("users","base_set")
    collection_fixtures("draft_measures",users_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user, Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
    sign_in @user
  end

  test "upload xml with valid VSAC creds" do
    # This cassette uses the ENV[VSAC_USERNAME] and ENV[VSAC_PASSWORD] which must be supplied
    # when the cassette needs to be generated for the first time.
    VCR.use_cassette("valid_vsac_response") do
      measure = Measure.where({hqmf_set_id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}).first
      assert_nil measure

      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('testplan', 'DischargedOnAntithrombotic_eMeasure.xml'), 'application/xml')

      # If you need to re-record the cassette for whatever reason, change the vsac_date to the current date
      post :create, {vsac_date: '06/28/2016', includes_draft: true, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient', vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD']}

      assert_response :redirect
      measure = Measure.where({hqmf_set_id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}).first
      assert_equal "40280381-3D27-5493-013D-4DCA4B826AE4", measure['hqmf_id']
    end
  end

  test "upload xml with invalid format" do
    VCR.use_cassette("valid_vsac_response") do
      measure = Measure.where({hqmf_set_id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}).first
      assert_nil measure
      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('testplan', 'DischargedOnAntithrombotic_eMeasure_Errored.xml'), 'application/xml')
      post :create, {vsac_date: '06/28/2016', includes_draft: true, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient', vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD']}

      assert_response :redirect
      assert_equal "Error Loading Measure", flash[:error][:title]
      assert_equal "Error loading XML file.", flash[:error][:summary]
      assert flash[:error][:body].starts_with?("There was an error loading the XML file you selected.  Please verify that the file you are uploading is an HQMF XML or SimpleXML file.")
    end
  end

  test "upload xml with invalid VSAC creds" do

    # This cassette represents an exchange with the VSAC authentication server that
    # results in an unauthorized response. This cassette is used in measures_controller_test.rb
    VCR.use_cassette("invalid_vsac_response") do

      # Ensure measure is not loaded to begin with
      measure = Measure.where({hqmf_set_id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"}).first
      assert_nil measure

      measure_file = fixture_file_upload(File.join('testplan', 'DischargedOnAntithrombotic_eMeasure.xml'), 'application/xml')
      # Post is sent with fake VSAC creds
      post :create, {vsac_date: '06/28/2016', includes_draft: true, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient', vsac_username: 'invaliduser', vsac_password: 'invalidpassword'}

      assert_response :redirect
      assert_equal "Error Loading VSAC Value Sets", flash[:error][:title]
      assert_equal "VSAC value sets could not be loaded.", flash[:error][:summary]
      assert flash[:error][:body].starts_with?("Please verify that you are using the correct VSAC username and password.")

    end
  end

  test "vsac auth valid" do

    # The ticket field was taken from the vcr_cassettes/valid_vsac_response file
    session[:tgt] = {ticket: "ST-67360-HgEfelIvwUQ3zz3X39fg-cas", expires: Time.now + 27000}
    get :vsac_auth_valid

    assert_response :ok
    assert_equal true, JSON.parse(response.body)['valid']
  end



  test "vsac auth invalid" do

    # Time is past expired
    # The ticket field was taken from the vcr_cassettes/valid_vsac_response file
    session[:tgt] = {ticket: "ST-67360-HgEfelIvwUQ3zz3X39fg-cas", expires: Time.now - 27000}
    get :vsac_auth_valid

    assert_response :ok
    assert_equal false, JSON.parse(response.body)['valid']
  end

  test "force expire vsac session" do
    # The ticket field was taken from the vcr_cassettes/valid_vsac_response file
    session[:tgt] = {ticket: "ST-67360-HgEfelIvwUQ3zz3X39fg-cas", expires: Time.now + 27000}
    get :vsac_auth_expire

    assert_response :ok
    assert_equal " ", response.body

    assert_nil session[:tgt]
    
    # Assert that vsac_auth_valid returns that vsac session is invalid
    get :vsac_auth_valid

    assert_response :ok
    assert_equal false, JSON.parse(response.body)['valid']

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
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_initial.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first

    get :value_sets, {id: measure.id, format: :json}
    assert_response :success
    assert_equal 29, JSON.parse(response.body).keys.count

  end

  test "upload invalid file format" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_invalid_extension.foo'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_equal "Error Loading Measure", flash[:error][:title]
    assert_equal "Incorrect Upload Format.", flash[:error][:summary]
    assert_equal "The file you have uploaded does not appear to be a Measure Authoring Tool zip export of a measure or HQMF XML measure file. Please re-export your measure from the MAT and select the 'eMeasure Package' option, or select the correct HQMF XML file.", flash[:error][:body]
    assert_response :redirect
  end

  test "upload invalid MAT zip" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_bad_MAT_export.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_equal "Error Uploading Measure", flash[:error][:title]
    assert_equal "The uploaded zip file is not a Measure Authoring Tool export.", flash[:error][:summary]
    assert_equal "You have uploaded a zip file that does not appear to be a Measure Authoring Tool zip file. If the zip file contains HQMF XML, please unzip the file and upload the HQMF XML file instead of the zip file. Otherwise, please re-export your measure from the MAT and select the 'eMeasure Package' option", flash[:error][:body]
    assert_response :redirect
  end

  test "upload measure already loaded" do
    sign_in @user
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_initial.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    # Assert measure is not yet loaded
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    assert_nil measure

    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    assert_not_nil measure

    update_measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_update.zip'), 'application/zip')
    # Now measure successfully uploaded, try to upload again
    post :create, {measure_file: update_measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_equal "Error Loading Measure", flash[:error][:title]
    assert_equal "A version of this measure is already loaded.", flash[:error][:summary]
    assert_equal "You have a version of this measure loaded already.  Either update that measure with the update button, or delete that measure and re-upload it.", flash[:error][:body]
    assert_response :redirect

    # Verify measure has not been deleted or modified
    measure_after = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    assert_equal measure, measure_after

  end

  test "update with hqmf set id mismatch" do

    # Upload the initial file
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_initial.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}

    # Upload a modified version of the initial file with a mismatching hqmf_set_id
    update_measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_initial_hqmf_setid_mismatch.zip'), 'application/zip')
    class << update_measure_file
      attr_reader :tempfile2
    end

    # The hqmf_set_id of the initial file is sent along with the create request
    post :create, {hqmf_set_id: "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure_file: update_measure_file}

    # Verify that the controller detects the mismatching hqmf_set_id and rejects
    assert_equal "Error Updating Measure", flash[:error][:title]
    assert_equal "The update file does not match the measure.", flash[:error][:summary]
    assert_equal "You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure.", flash[:error][:body]
    assert_response :redirect

    # Verify that the initial file remained unchanged
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    assert_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure.hqmf_set_id
  end

  test "upload missing value set missing oid" do

    # The 'principal diagnosis' oid was changed in DischargedonAntithromboticThe_eMeasure.xml within measure_initial_valueset_oid_mismatch.zip from 2.16.840.1.113883.3.117.2.7.1.14 to 2.16.840.1.113883.3.117.2.7.1.15
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_initial_valueset_oid_mismatch.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}

    assert_equal "Measure is missing value sets",flash[:error][:title]
    assert_equal "The measure you have tried to load is missing value sets.", flash[:error][:summary]
    assert_equal "The measure you are trying to load is missing value sets.  Try re-packaging and re-exporting the measure from the Measure Authoring Tool.  The following value sets are missing: [2.16.840.1.113883.3.117.2.7.1.15]", flash[:error][:body]

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

  test "create/finalize/update a measure" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_initial.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    # Initial create of measure
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first

    assert_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure.hqmf_set_id
    assert_equal 29, measure.value_sets.count
    assert_equal @user.id, measure.user_id
    measure.value_sets.each {|vs| assert_equal @user.id, vs.user_id}
    assert_equal true, measure.needs_finalize
    assert_equal true, measure.episode_of_care?
    assert_equal 'eh', measure.type
    assert_nil measure.population_criteria['DENOM']['preconditions']
    assert_nil measure.episode_ids
    assert_operator measure.map_fns[0].length, :>, 100

    assert_equal "FAKE_941657", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.93'}).first.concepts.first.code
    assert_equal "FAKE_977601", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.201'}).first.concepts.first.code
    assert_equal "FAKE_312269", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.233'}).first.concepts.first.code
    assert_equal "FAKE_312269", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.212'}).first.concepts.first.code
    assert_equal "FAKE_435307", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.247'}).first.concepts.first.code

    # Finalize the measure that was just created
    post :finalize, {"t679"=>{"hqmf_id"=>"40280381-3D27-5493-013D-4DCA4B826AE4","episode_ids"=>["OccurrenceAInpatientEncounter1"]}}
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    assert_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure.hqmf_set_id
    assert_equal 29, measure.value_sets.count
    assert_equal @user.id, measure.user_id
    measure.value_sets.each {|vs| assert_equal @user.id, vs.user_id}
    assert_equal false, measure.needs_finalize
    assert_equal true, measure.episode_of_care?
    assert_equal 'eh', measure.type
    assert_nil measure.population_criteria['DENOM']['preconditions']
    assert_includes measure.episode_ids, 'OccurrenceAInpatientEncounter1'
    assert_equal 1, measure.episode_ids.length
    assert_operator measure.map_fns[0].length, :>, 100

    # Update the measure that was just finalized
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_update.zip'), 'application/zip')
    post :create, {measure_file: measure_file, hqmf_set_id: measure.hqmf_set_id, 'eoc_42BF391F-38A3-4C0F-9ECE-DCD47E9609D9'=>{'episode_ids'=>['OccurrenceAInpatientEncounter1']}}
    assert_response :redirect

    # Ensure changes made in the update stuck
    measure = Measure.where({hqmf_id: '40280381-3D27-5493-013D-4DCA4B826XXX'}).first
    assert_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure.hqmf_set_id
    assert_equal 29, measure.value_sets.count
    assert_equal @user.id, measure.user_id
    measure.value_sets.each {|vs| assert_equal @user.id, vs.user_id}
    assert_equal false, measure.needs_finalize
    assert_equal true, measure.episode_of_care?
    assert_equal 'eh', measure.type
    assert_includes measure.episode_ids, 'OccurrenceAInpatientEncounter1'
    assert_equal 1, measure.episode_ids.length
    assert_operator measure.map_fns[0].length, :>, 100

    assert !measure.population_criteria['DENOM']['preconditions'].nil?
    assert_equal 1, measure.population_criteria['DENOM']['preconditions'].count

    assert_equal "UPDATED_435838", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.93'}).first.concepts.first.code
    assert_equal "UPDATED_144582", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.201'}).first.concepts.first.code
    assert_equal "UPDATED_802054", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.233'}).first.concepts.first.code
    assert_equal "UPDATED_802054", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.212'}).first.concepts.first.code
    assert_equal "UPDATED_224349", (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.247'}).first.concepts.first.code

  end

  test "load with no vs" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_no_vs.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first

    assert_nil measure
    assert_includes flash[:error].keys, :title
    assert_includes flash[:error].keys, :summary
    assert_includes flash[:error].keys, :body
    assert_equal 'The measure value sets could not be found.', flash[:error][:summary]
    flash.clear

    assert_equal 2, Dir.glob(File.join(@error_dir,'**')).count
  end

  test "load EoC with no Specifics" do
    # fails to load with as EoC
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'no_ipp_Artifacts.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect

    measure = Measure.where({hqmf_id: "40280381-446B-B8C2-0144-C0DED70A363B"}).first
    assert_nil measure
    assert_includes flash[:error].keys, :title
    assert_includes flash[:error].keys, :summary
    assert_includes flash[:error].keys, :body
    assert_equal 'An episode of care measure requires at least one specific occurrence for the episode of care.', flash[:error][:summary]
    flash.clear

    # loads patient based
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'no_ipp_Artifacts.zip'), 'application/zip')
    post :create, {measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'}
    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-446B-B8C2-0144-C0DED70A363B"}).first
    assert_equal "09FB4924-D340-4190-BAB9-E7764C8665CA", measure.hqmf_set_id
    assert_equal "Test No IPP", measure.title
    assert_nil flash[:error]
  end

  test "load HQMF bad xml" do
    
    # fails to load with bad hqmf
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
    assert_includes flash[:error].keys, :body
    assert_equal 'The measure could not be loaded.', flash[:error][:summary]
    flash.clear

    assert_equal 2, Dir.glob(File.join(@error_dir, '**')).count
  end

  test "load with no zip" do
    post :create, {measure_file: nil, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect

    assert_includes flash[:error].keys, :title
    assert_includes flash[:error].keys, :body
    assert_equal 'You must specify a Measure Authoring tool measure export to use.', flash[:error][:body]
    flash.clear
  end

  test "debug test" do
    get :debug, {id: @measure.id}
    assert_response :success
  end


  test "update a patient based measure" do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_initial.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'patient'}

    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    assert_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure.hqmf_set_id

    post :create, {measure_file: measure_file, hqmf_set_id: measure.hqmf_set_id}

    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    assert_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9", measure.hqmf_set_id
  end

end
