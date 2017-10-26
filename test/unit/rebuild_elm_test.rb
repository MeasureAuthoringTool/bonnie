require 'test_helper'
require 'vcr_setup.rb'

class RebuildElmTest < ActiveSupport::TestCase    
  setup do
    @cql_mat_export = File.new File.join('test', 'fixtures', 'cql_measure_exports', 'Test134_v5_4_Artifacts.zip')
    Bonnie::Application.load_tasks
  end

  test "rebuild elm with stored MAT package" do
    VCR.use_cassette("mat_5_4_valid_vsac_response") do
      dump_database
      @user = User.new(email: "test@test.com", first: "first" , last: 'last',password: 'Test1234!') 
      @user.save!
      assert_equal 1, User.count

      measure_details = { 'episode_of_care'=> false }
      Measures::CqlLoader.load(@cql_mat_export, @user, measure_details, ENV['VSAC_USERNAME'], ENV['VSAC_PASSWORD']).save
      assert_equal 1, CqlMeasure.count
  
      measure = CqlMeasure.where({hqmf_set_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747"}).first
      assert_equal "40280582-5C27-8179-015C-308B1F99003B", measure['hqmf_id']
      assert_equal 'Test CMS 134', measure['title']

      # Modify some of the measure model
      measure.title = 'foo'
      measure.cql = nil
      measure.elm_annotations = nil
      measure.save
      # Confirm measure model saved corectly.       
      assert_nil measure.cql
      assert_nil measure.elm_annotations

      # Run rake task on all cql measures
      Rake::Task['bonnie:cql:rebuild_elm'].execute
      measure = CqlMeasure.where({hqmf_set_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747"}).first
      # Confirm that measure title did not update.
      assert_equal measure.title, 'foo'
      
      # Confirm that the CQL and ELM annotations were updated.
      assert_not_equal nil, measure.cql
      assert_not_equal nil, measure.elm_annotations
      measure.delete
    end 
  end

  test "rebuild elm using translation service" do
    dump_database
    @user = User.new(email: "test@test.com", first: "first" , last: 'last',password: 'Test1234!') 
    @user.save!
    assert_equal 1, User.count

    VCR.use_cassette("mat_5_4_valid_vsac_response") do
       measure_details = { 'episode_of_care'=> false }
       Measures::CqlLoader.load(@cql_mat_export, @user, measure_details, ENV['VSAC_USERNAME'], ENV['VSAC_PASSWORD']).save
       assert_equal 1, CqlMeasure.count
    end

    measure = CqlMeasure.where({hqmf_set_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747"}).first
    assert_equal "40280582-5C27-8179-015C-308B1F99003B", measure['hqmf_id']

    # Modify some of the measure model
    measure.title = 'No mat package'
    measure.elm_annotations = nil

    # Remove the stored MAT package from the DB
    package = CqlMeasurePackage.all.first
    package.delete
    measure.save

    # Confirm measure model saved corectly.       
    assert_nil measure.elm_annotations
    assert_nil measure.package

    VCR.use_cassette("valid_translation_response") do
      # Run rake task on all cql measures
      Rake::Task['bonnie:cql:rebuild_elm'].execute
    end
    
    measure = CqlMeasure.where({hqmf_set_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747"}).first
    # Confirm that measure title did not update.
    assert_equal measure.title, 'No mat package'

    # Confirm there is still now associated MAT package.
    assert_nil measure.package

    # Confirm that the ELM annotations were updated.
    assert_not_equal nil, measure.elm_annotations 
    measure.delete
  end

end
