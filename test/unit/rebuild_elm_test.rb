require 'test_helper'
require 'vcr_setup.rb'

class RebuildElmTest < ActiveSupport::TestCase    
  setup do
    dump_database
    @cql_mat_export = File.new File.join('test', 'fixtures', 'cql_measure_exports', 'Test134_v5_4_Artifacts.zip')
    @cql_mat_export_drc = File.new File.join('test', 'fixtures', 'cql_measure_exports', 'CMS26v5_Artifacts_direct_reference_code.zip')
    @user = User.new(email: "test@test.com", first: "first" , last: 'last',password: 'Test1234!')
    @user.save!
    assert_equal 1, User.count
  end

  test "direct reference codes update properly during rebuild elm" do
    VCR.use_cassette("direct_reference_code_valid_vsac_response") do
      measure_details = { 'episode_of_care'=> true }

      Measures::CqlLoader.load(@cql_mat_export_drc, @user, measure_details, ENV['VSAC_USERNAME'], ENV['VSAC_PASSWORD']).save
      assert_equal 1, CqlMeasure.count

      measure = CqlMeasure.where({hqmf_set_id: "E1CB05E0-97D5-40FC-B456-15C5DBF44309"}).first
      assert_equal "40280382-5FA6-FE85-015F-C17306910ECF", measure['hqmf_id']
      assert_equal 'Home Management Plan of Care (HMPC) Document Given to Patient/Caregiver', measure['title']

      # Grab the Data Criteria code_list_id of the direct reference code data criteria.
      dc_code_list_id = measure.data_criteria['prefix_69981_9_Communication_FromProviderToPatient_C5F6108B_658C_4114_A1B5_F65D8FEE155F']['code_list_id']

      # Run rake task on all cql measures
      Rake::Task['bonnie:cql:rebuild_elm'].execute
      measure = CqlMeasure.where({hqmf_set_id: "E1CB05E0-97D5-40FC-B456-15C5DBF44309"}).first
      # Confirm that the data criteria's code_list_id has a different GUID than before the rebuild_elm.
      assert_not_equal dc_code_list_id, measure.data_criteria['prefix_69981_9_Communication_FromProviderToPatient_C5F6108B_658C_4114_A1B5_F65D8FEE155F']['code_list_id']

      # Confirm that the new code_list_id matches an item in the value_set_oids list
      assert measure.value_set_oids.include? measure.data_criteria['prefix_69981_9_Communication_FromProviderToPatient_C5F6108B_658C_4114_A1B5_F65D8FEE155F']['code_list_id']

      measure.delete
    end
  end

  test "rebuild elm with stored MAT package" do
    VCR.use_cassette("mat_5_4_valid_vsac_response") do
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

    # Confirm there is still no associated MAT package.
    assert_nil measure.package

    # Confirm that the ELM annotations were updated.
    assert_not_equal nil, measure.elm_annotations
    measure.delete
  end

end
