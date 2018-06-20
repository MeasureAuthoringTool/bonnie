require 'test_helper'
require 'vcr_setup.rb'

class CqlTest < ActiveSupport::TestCase    
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

      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
      vsac_ticket_granting_ticket = api.ticket_granting_ticket
      vsac_options = { measure_defined: true, profile: APP_CONFIG['vsac']['default_profile'] }

      Measures::CqlLoader.load(@cql_mat_export_drc, @user, measure_details, vsac_options, vsac_ticket_granting_ticket).save
      assert_equal 1, CqlMeasure.count

      measure = CqlMeasure.where({hqmf_set_id: "E1CB05E0-97D5-40FC-B456-15C5DBF44309"}).first
      assert_equal "40280382-5FA6-FE85-015F-C17306910ECF", measure['hqmf_id']
      assert_equal 'Home Management Plan of Care (HMPC) Document Given to Patient/Caregiver', measure['title']

      # Grab the Data Criteria code_list_id of the direct reference code data criteria.
      dc_code_list_id = measure.data_criteria['prefix_69981_9_Communication_FromProviderToPatient_C5F6108B_658C_4114_A1B5_F65D8FEE155F']['code_list_id']

      # Run rake task on all cql measures
      Rake::Task['bonnie:patients:rebuild_elm_update_drc_code_list_ids'].execute
      measure = CqlMeasure.where({hqmf_set_id: "E1CB05E0-97D5-40FC-B456-15C5DBF44309"}).first

      # Confirm that the data criteria's code_list_id has the same GUID as it did before the rebuild_elm
      # (since the DRC did not change in the cql between before and after the rebuild elm)
      assert_equal dc_code_list_id, measure.data_criteria['prefix_69981_9_Communication_FromProviderToPatient_C5F6108B_658C_4114_A1B5_F65D8FEE155F']['code_list_id']

      # Confirm that the code_list_id matches an item in the value_set_oids list
      assert measure.value_set_oids.include? measure.data_criteria['prefix_69981_9_Communication_FromProviderToPatient_C5F6108B_658C_4114_A1B5_F65D8FEE155F']['code_list_id']

      measure.delete
    end
  end

  test "rebuild elm with stored MAT package" do
    VCR.use_cassette("mat_5_4_valid_vsac_response") do
      measure_details = { 'episode_of_care'=> false }

      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
      vsac_ticket_granting_ticket = api.ticket_granting_ticket
      vsac_options = { measure_defined: true, profile: APP_CONFIG['vsac']['default_profile'] }

      Measures::CqlLoader.load(@cql_mat_export, @user, measure_details, vsac_options, vsac_ticket_granting_ticket).save
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

       api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: ENV['VSAC_USERNAME'], password: ENV['VSAC_PASSWORD'])
       vsac_ticket_granting_ticket = api.ticket_granting_ticket
       vsac_options = { measure_defined: true, profile: APP_CONFIG['vsac']['default_profile'] }

       Measures::CqlLoader.load(@cql_mat_export, @user, measure_details, vsac_options, vsac_ticket_granting_ticket).save
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

  test "cql measure stats" do
    users_set = File.join("users", "base_set")
    cql_measures_set_1 = File.join("cql_measures", "CMS347v1")
    cql_measures_set_2 = File.join("cql_measures", "CMS160v6")
    cql_measures_set_3 = File.join("cql_measures", "CMS72v5")
    collection_fixtures(users_set)
    add_collection(cql_measures_set_1)
    add_collection(cql_measures_set_2)
    add_collection(cql_measures_set_3)

    @hqmf_set_id_1 = '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2'
    @hqmf_set_id_2 = '93F3479F-75D8-4731-9A3F-B7749D8BCD37'
    @hqmf_set_id_3 = 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'

    @second_user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user, CqlMeasure.where(hqmf_set_id: @hqmf_set_id_1))
    associate_user_with_measures(@user, CqlMeasure.where(hqmf_set_id: @hqmf_set_id_2))
    associate_user_with_measures(@second_user, CqlMeasure.where(hqmf_set_id: @hqmf_set_id_3))

    measure_1 = CqlMeasure.where(hqmf_set_id: @hqmf_set_id_1).first
    measure_2 = CqlMeasure.where(hqmf_set_id: @hqmf_set_id_2).first
    measure_3 = CqlMeasure.where(hqmf_set_id: @hqmf_set_id_3).first

    assert_output(
      "User: #{@user.email}\n" +
      "  CMS_ID: #{measure_1.cms_id}  TITLE: #{measure_1.title}\n" +
      "  CMS_ID: #{measure_2.cms_id}  TITLE: #{measure_2.title}\n" +
      "User: #{@second_user.email}\n" +
      "  CMS_ID: #{measure_3.cms_id}  TITLE: #{measure_3.title}\n"
     ) { Rake::Task['bonnie:cql:cql_measure_stats'].execute }
  end

end
