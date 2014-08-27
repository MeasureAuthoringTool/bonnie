require 'test_helper'

class MeasuresControllerTest  < ActionController::TestCase
include Devise::TestHelpers
      
  setup do
    @error_dir = File.join('log','load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    collection_fixtures("draft_measures", "users")
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user,Measure.all)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
    sign_in @user
  end

  test "measure show" do
    get :show, {id: @measure.id, format: :json}
    assert_response :success
    measure = JSON.parse(response.body)
    measure['id'].must_equal @measure.id
    measure['title'].must_equal @measure.title
    measure['hqmf_id'].must_equal @measure.hqmf_id
    measure['hqmf_set_id'].must_equal @measure.hqmf_set_id
    measure['cms_id'].must_equal @measure.cms_id
    measure['map_fns'].must_be_nil
    measure['record_ids'].must_be_nil
    measure['measure_attributes'].must_be_nil
  end

  test "measure destroy" do
    m2 = @measure.dup
    m2.hqmf_id = 'xxx123'
    m2.hqmf_set_id = 'yyy123'
    m2.save!
    Measure.all.count.must_equal 3
    delete :destroy, {id: m2.id}
    assert_response :success
    Measure.all.count.must_equal 2
  end

  test "measure value sets" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first

    get :value_sets, {id: measure.id, format: :json}
    assert_response :success
    JSON.parse(response.body).keys.count.must_equal 29

  end

  test "measure clear cached javascript" do
    tmp_fns = @measure.map_fns
    @measure.map_fns = ['foo']
    @measure.save!
    @measure.reload
    @measure.map_fns[0].length.must_equal 3
    request.env["HTTP_REFERER"] = 'http://localhost/'
    get :clear_cached_javascript, {id: @measure.id}
    assert_response :redirect
    @measure.reload
    Measure.all.first.map_fns[0].length.must_be :>,100
  end

  test "create/finalize/update a measure" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first

    measure.hqmf_set_id.must_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"
    measure.value_sets.count.must_equal 29
    measure.user_id.must_equal @user.id
    measure.value_sets.each {|vs| vs.user_id.must_equal @user.id}
    measure.needs_finalize.must_equal true
    measure.episode_of_care?.must_equal true
    measure.type.must_equal 'eh'
    measure.population_criteria['DENOM']['preconditions'].must_be_nil
    measure.episode_ids.must_be_nil
    measure.map_fns[0].length.must_be :>,100

    (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.93'}).first.concepts.first.code.must_equal "FAKE_941657"
    (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.201'}).first.concepts.first.code.must_equal "FAKE_977601"
    (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.233'}).first.concepts.first.code.must_equal "FAKE_312269"
    (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.212'}).first.concepts.first.code.must_equal "FAKE_312269"
    (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.247'}).first.concepts.first.code.must_equal "FAKE_435307"

    post :finalize, {"t679"=>{"hqmf_id"=>"40280381-3D27-5493-013D-4DCA4B826AE4","episode_ids"=>["OccurrenceAInpatientEncounter1"]}}
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    measure.hqmf_set_id.must_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"
    measure.value_sets.count.must_equal 29
    measure.user_id.must_equal @user.id
    measure.value_sets.each {|vs| vs.user_id.must_equal @user.id}
    measure.needs_finalize.must_equal false
    measure.episode_of_care?.must_equal true
    measure.type.must_equal 'eh'
    measure.population_criteria['DENOM']['preconditions'].must_be_nil
    measure.episode_ids.must_include 'OccurrenceAInpatientEncounter1'
    measure.episode_ids.length.must_equal 1
    measure.map_fns[0].length.must_be :>,100

    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_update.zip'),'application/zip')
    post :create, {measure_file: measure_file, hqmf_set_id: measure.hqmf_set_id, 'eoc_42BF391F-38A3-4C0F-9ECE-DCD47E9609D9'=>{'episode_ids'=>['OccurrenceAInpatientEncounter1']}}
    assert_response :redirect

    measure = Measure.where({hqmf_id: '40280381-3D27-5493-013D-4DCA4B826XXX'}).first
    measure.hqmf_set_id.must_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"
    measure.value_sets.count.must_equal 29
    measure.user_id.must_equal @user.id
    measure.value_sets.each {|vs| vs.user_id.must_equal @user.id}
    measure.needs_finalize.must_equal false
    measure.episode_of_care?.must_equal true
    measure.type.must_equal 'eh'
    measure.episode_ids.must_include 'OccurrenceAInpatientEncounter1'
    measure.episode_ids.length.must_equal 1
    measure.map_fns[0].length.must_be :>,100

    assert !measure.population_criteria['DENOM']['preconditions'].nil?
    assert measure.population_criteria['DENOM']['preconditions'].count.must_equal 1

    (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.93'}).first.concepts.first.code.must_equal "UPDATED_435838"
    (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.201'}).first.concepts.first.code.must_equal "UPDATED_144582"
    (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.233'}).first.concepts.first.code.must_equal "UPDATED_802054"
    (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.212'}).first.concepts.first.code.must_equal "UPDATED_802054"
    (measure.value_sets.select {|vs| vs.oid == '2.16.840.1.113883.3.117.1.7.1.247'}).first.concepts.first.code.must_equal "UPDATED_224349"

  end

  test "load with no vs" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_no_vs.zip'),'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first

    measure.must_be_nil
    flash[:error].keys.must_include :title
    flash[:error].keys.must_include :summary
    flash[:error].keys.must_include :body
    flash[:error][:summary].must_equal 'The measure value sets could not be found.'
    flash.clear

    Dir.glob(File.join(@error_dir,'**')).count.must_equal 2

  end

  test "load EoC with no Specifics" do
    # fails to load with as EoC
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','no_ipp_Artifacts.zip'),'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect

    measure = Measure.where({hqmf_id: "40280381-446B-B8C2-0144-C0DED70A363B"}).first
    measure.must_be_nil
    flash[:error].keys.must_include :title
    flash[:error].keys.must_include :summary
    flash[:error].keys.must_include :body
    flash[:error][:summary].must_equal 'An episode of care measure requires at least one specific occurrence for the episode of care.'
    flash.clear

    # loads patient based
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','no_ipp_Artifacts.zip'),'application/zip')
    post :create, {measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'}
    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-446B-B8C2-0144-C0DED70A363B"}).first
    measure.hqmf_set_id.must_equal "09FB4924-D340-4190-BAB9-E7764C8665CA"
    measure.title.must_equal "Test No IPP"
    flash[:error].must_be_nil
  end

  test "load HQMF bad xml" do
    # fails to load with bad hqmf
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_bad_hqmf.zip'),'application/zip')
    class << measure_file
      attr_reader :tempfile
    end
    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect

    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first

    measure.must_be_nil
    flash[:error].keys.must_include :title
    flash[:error].keys.must_include :summary
    flash[:error].keys.must_include :body
    flash[:error][:summary].must_equal 'The measure could not be loaded.'
    flash.clear

    Dir.glob(File.join(@error_dir,'**')).count.must_equal 2
  end

  test "load with no zip" do
    post :create, {measure_file: nil, measure_type: 'eh', calculation_type: 'episode'}
    assert_response :redirect

    flash[:error].keys.must_include :title
    flash[:error].keys.must_include :body
    flash[:error][:body].must_equal 'You must specify a Measure Authoring tool measure export to use.'
    flash.clear

  end

  test "debug test" do
    get :debug, {id: @measure.id}
    assert_response :success
  end


  test "update a patient based measure" do
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    post :create, {measure_file: measure_file, measure_type: 'eh', calculation_type: 'patient'}

    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    measure.hqmf_set_id.must_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"

    post :create, {measure_file: measure_file, hqmf_set_id: measure.hqmf_set_id}

    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-3D27-5493-013D-4DCA4B826AE4"}).first
    measure.hqmf_set_id.must_equal "42BF391F-38A3-4C0F-9ECE-DCD47E9609D9"

  end

end
