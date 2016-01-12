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
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
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
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

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

    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_update.zip'),'application/zip')
    post :create, {measure_file: measure_file, hqmf_set_id: measure.hqmf_set_id, 'eoc_42BF391F-38A3-4C0F-9ECE-DCD47E9609D9'=>{'episode_ids'=>['OccurrenceAInpatientEncounter1']}}
    assert_response :redirect

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
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_no_vs.zip'),'application/zip')
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
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','no_ipp_Artifacts.zip'),'application/zip')
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
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','no_ipp_Artifacts.zip'),'application/zip')
    post :create, {measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient'}
    assert_response :redirect
    measure = Measure.where({hqmf_id: "40280381-446B-B8C2-0144-C0DED70A363B"}).first
    assert_equal "09FB4924-D340-4190-BAB9-E7764C8665CA", measure.hqmf_set_id
    assert_equal "Test No IPP", measure.title
    assert_nil flash[:error]
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

    assert_nil measure
    assert_includes flash[:error].keys, :title
    assert_includes flash[:error].keys, :summary
    assert_includes flash[:error].keys, :body
    assert_equal 'The measure could not be loaded.', flash[:error][:summary]
    flash.clear

    assert_equal 2, Dir.glob(File.join(@error_dir,'**')).count
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
    measure_file = fixture_file_upload(File.join('test','fixtures','measure_exports','measure_initial.zip'),'application/zip')
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
