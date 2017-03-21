require 'test_helper'

class MeasuresControllerMeasureHistoryTest < ActionController::TestCase
include Devise::TestHelpers

  tests MeasuresController

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    sign_in @user

    records_set = File.join("records","measure_history_set")
    collection_fixtures(records_set)
    @patients = Record
    associate_user_with_patients(@user, @patients)
    Record.each do |patient|
      if patient['user_id'].is_a?(String)
        patient['user_id'] = BSON::ObjectId.from_string(patient['user_id'])
        patient.save!
      end
    end
  end

  test 'walk through measure population_set change scenarios' do
    # Load version 1 of the measure. Starts with two population sets
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS704_v1.1.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    # Assert measure is not yet loaded
    measure = Measure.where(hqmf_set_id: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F', user_id: @user.id).first
    assert_nil measure
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional'

    assert_response :redirect
    measure = Measure.where(cms_id: 'CMS704v1', user_id: @user.id).first
    assert_equal 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F', measure.hqmf_set_id
    assert_equal '40280382-5859-6598-0158-89421C4E071B', measure.hqmf_id
    assert_equal 2, measure.populations.count # Does the measure now have 2 population sets

    # Go from two population sets to three
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS704_v2.2.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional', hqmf_set_id: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F'

    assert_response :redirect
    measure = Measure.where(hqmf_id: '40280382-5859-6598-0158-92BE72260A7E', user_id: @user.id).first
    assert_equal 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F', measure.hqmf_set_id
    assert_equal 3, measure.populations.count # Does the measure now have 3 population sets

    upload_summary = UploadSummary::MeasureSummary.where(hqmf_id: '40280382-5859-6598-0158-92BE72260A7E').first
    assert_not_nil upload_summary # There is an upload summary
    assert_equal 3, upload_summary.population_set_summaries.count # Represents that there are 3 population sets
    assert_equal 2, upload_summary.measure_population_set_count[:pre_upload]
    assert_equal 3, upload_summary.measure_population_set_count[:post_upload]

    test_patient = Record.where(measure_ids: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F').first

    # Check that for the patient the first population set has expected, pre_upload_results, and post_upload_results
    assert_not_nil upload_summary.population_set_summaries[0]['patients'][test_patient.id.to_s]['expected']
    assert_not_nil upload_summary.population_set_summaries[0]['patients'][test_patient.id.to_s]['pre_upload_results']
    assert_not_nil upload_summary.population_set_summaries[0]['patients'][test_patient.id.to_s]['post_upload_results']

    # Check that for the patient the second population set has expected, pre_upload_results, and post_upload_results
    assert_not_nil upload_summary.population_set_summaries[1]['patients'][test_patient.id.to_s]['expected']
    assert_not_nil upload_summary.population_set_summaries[1]['patients'][test_patient.id.to_s]['pre_upload_results']
    assert_not_nil upload_summary.population_set_summaries[1]['patients'][test_patient.id.to_s]['post_upload_results']

    # Check that for the patient the third population set has expected, and the expected match the populations for the 3 population set, post_upload_results
    assert_not_nil upload_summary.population_set_summaries[2]['patients'][test_patient.id.to_s]['expected']
    # Make sure the number of and names of the populations match up
    assert_equal 0, (upload_summary.population_set_summaries[2]['patients'][test_patient.id.to_s]['expected'].keys - measure.populations[2].keys).count
    # The third population set only exists post upload so there should only be post_upload_results.
    assert_nil upload_summary.population_set_summaries[2]['patients'][test_patient.id.to_s]['pre_upload_results']
    assert_not_nil upload_summary.population_set_summaries[2]['patients'][test_patient.id.to_s]['post_upload_results']

    # Go from three population sets to one
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS704_v3.1.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional', hqmf_set_id: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F'

    assert_response :redirect
    measure = Measure.where(hqmf_id: '40280382-5859-6598-0158-932E80DC0AD5', user_id: @user.id).first
    assert_equal 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F', measure.hqmf_set_id

    upload_summary = UploadSummary::MeasureSummary.where(hqmf_id: '40280382-5859-6598-0158-932E80DC0AD5').first
    assert_not_nil upload_summary # There is an upload summary
    assert_equal 3, upload_summary.population_set_summaries.count
    assert_equal 3, upload_summary.measure_population_set_count[:pre_upload]
    assert_equal 1, upload_summary.measure_population_set_count[:post_upload]

    assert_not_nil upload_summary.population_set_summaries[0]['patients'][test_patient.id.to_s]['expected']
    assert_not_nil upload_summary.population_set_summaries[0]['patients'][test_patient.id.to_s]['pre_upload_results']
    assert_not_nil upload_summary.population_set_summaries[0]['patients'][test_patient.id.to_s]['post_upload_results']

    # Check that for the patient the second population set has expected, pre_upload_results, and no post_upload_results
    assert_not_nil upload_summary.population_set_summaries[1]['patients'][test_patient.id.to_s]['expected']
    assert_not_nil upload_summary.population_set_summaries[1]['patients'][test_patient.id.to_s]['pre_upload_results']
    assert_nil upload_summary.population_set_summaries[1]['patients'][test_patient.id.to_s]['post_upload_results']

    # Check that for the patient the third population set has expected, pre_upload_results, and no post_upload_results
    assert_not_nil upload_summary.population_set_summaries[2]['patients'][test_patient.id.to_s]['expected']
    assert_not_nil upload_summary.population_set_summaries[2]['patients'][test_patient.id.to_s]['pre_upload_results']
    assert_nil upload_summary.population_set_summaries[2]['patients'][test_patient.id.to_s]['post_upload_results']

    # Go back to the original state of two population sets
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS704_v1.1.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional', hqmf_set_id: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F'

    assert_response :redirect
    measure = Measure.where(cms_id: 'CMS704v1', user_id: @user.id).first
    assert_equal 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F', measure.hqmf_set_id
    assert_equal '40280382-5859-6598-0158-89421C4E071B', measure.hqmf_id
    upload_summary = UploadSummary::MeasureSummary.where(hqmf_id: '40280382-5859-6598-0158-89421C4E071B').last
    assert_equal 1, upload_summary.measure_population_set_count[:pre_upload]
    assert_equal 2, upload_summary.measure_population_set_count[:post_upload]

    # Now load a version of the measure where the number of population sets stays constant
    # but the populations within those sets change

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS704_v2.3.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional', hqmf_set_id: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F'

    test_patient = Record.where(measure_ids: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F').first
    assert_response :redirect
    measure = Measure.where(hqmf_set_id: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F', user_id: @user.id).first
    assert_equal '40280382-5859-6598-0158-9339D1600AEF', measure.hqmf_id
    upload_summary = UploadSummary::MeasureSummary.where(hqmf_id: '40280382-5859-6598-0158-9339D1600AEF').last
    assert_equal 2, upload_summary.measure_population_set_count[:pre_upload]
    assert_equal 2, upload_summary.measure_population_set_count[:post_upload]

    # Check that the expected value populations for each population set on the patient
    # match those on the measure
    measure.populations.each_with_index do |population_set, set_index|
      assert_equal [], ((test_patient.expected_values[set_index].keys - population_set.keys) - %w(measure_id population_index))
      assert_equal [], ((population_set.keys - test_patient.expected_values[set_index].keys) - %w(id title))
    end
  end # test

  test 'Archived Measures added upon reuploading' do
    # Load initial measure
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS704_v1.1.zip'), 'application/zip')
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional'
    measure = Measure.where(hqmf_set_id: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F', user_id: @user.id).first
    # Assert measure has no history upon initial upload
    assert_equal 0, ArchivedMeasure.where({hqmf_set_id: measure.hqmf_set_id}).count
    
    # Load new version of measure
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS704_v2.2.zip'), 'application/zip')
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional', hqmf_set_id: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F'
    measure = Measure.where(hqmf_id: '40280382-5859-6598-0158-92BE72260A7E', user_id: @user.id).first
    # Assert there is one ArchivedMeasure loaded
    assert_equal 1, ArchivedMeasure.where({hqmf_set_id: measure.hqmf_set_id}).count

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS704_v3.1.zip'), 'application/zip')
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional', hqmf_set_id: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F'
    measure = Measure.where(hqmf_id: '40280382-5859-6598-0158-932E80DC0AD5', user_id: @user.id).first
    # Assert there are two ArchivedMeasures loaded
    assert_equal 2, ArchivedMeasure.where({hqmf_set_id: measure.hqmf_set_id}).count

    # Reupload the intital measure version
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS704_v1.1.zip'), 'application/zip')
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional', hqmf_set_id: 'E37012AD-2B01-4738-8985-D5C0F4C3AE9F'
    measure = Measure.where(cms_id: 'CMS704v1', user_id: @user.id).first
    # Assert there are three ArchivedMeasure loaded
    assert_equal 3, ArchivedMeasure.where({hqmf_set_id: measure.hqmf_set_id}).count
  end 

  # This test is focusing on the actions around measure updates, particularly taking the snapshots of the patitents before and after
  test 'update measure version' do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS123v3.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    # Assert measure is not yet loaded
    measure = Measure.where(hqmf_id: '40280381-4555-E1C1-0145-E20602FE49E').first
    assert_nil measure

    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional'

    assert_response :redirect
    measure = Measure.where(hqmf_id: '40280381-4555-E1C1-0145-E20602FE49E8').first
    assert_equal 'C0D72444-7C26-4863-9B51-8080F8928A85', measure.hqmf_set_id
    # Find a patient and force the size of the calc_results over the 12MB limit
    p = Record.where(first: 'John, III', measure_ids: 'C0D72444-7C26-4863-9B51-8080F8928A85').first

    p.calc_results[0][:rationale] = 'X' * (1024 * 1024 * 12)
    p.save

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS123v5.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional', hqmf_set_id: 'C0D72444-7C26-4863-9B51-8080F8928A85'

    measure = Measure.where(cms_id: 'CMS123v5').first
    assert_equal 'C0D72444-7C26-4863-9B51-8080F8928A85', measure.hqmf_set_id
    assert_equal '40280381-51F0-825B-0152-229B7B2F16F9', measure.hqmf_id

    upload_summary = UploadSummary::MeasureSummary.where(hqmf_id: '40280381-51F0-825B-0152-229B7B2F16F9').first
    assert_not_nil upload_summary
    assert_equal 'CMS123v3', upload_summary.cms_id_pre_upload
    assert_equal 'CMS123v5', upload_summary.cms_id_post_upload
    assert_equal 3, upload_summary.population_set_summaries[0][:summary][:pass_before]
    assert_equal 3, upload_summary.population_set_summaries[0][:summary][:pass_after]
    assert_equal true, upload_summary.population_set_summaries[0][:patients][p.id.to_s][:results_exceeds_storage_pre_upload]
    assert_equal false, upload_summary.population_set_summaries[0][:patients][p.id.to_s][:results_exceeds_storage_post_upload]
  end
  
  test 'measure archived on delete' do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'CMS123v3.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    # create measure to delete
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'proportional'
    assert_response :redirect

    # grab the database id of the new measure
    measure = Measure.by_user(@user).where(hqmf_set_id: 'C0D72444-7C26-4863-9B51-8080F8928A85').first;
    assert_not_nil measure
    measure_db_id = measure._id

    # delete measure
    delete :destroy, id: measure_db_id.to_s
    assert_response :success

    # ensure an archived measure was created for the measure
    assert_equal 1, ArchivedMeasure.by_user(@user).where(measure_db_id: measure_db_id).count
  end

  test 'measure archiving' do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'base_example', 'CMS68v4.zip'), 'application/zip')

    # Assert measure is not yet loaded
    measure = Measure.where(hqmf_set_id: '9A032D9C-3D9B-11E1-8634-00237D5BF174', user_id: @user.id).first
    assert_nil measure
    # Assert that there is nothing in the archive for this measure
    assert_equal 0, ArchivedMeasure.by_user_and_hqmf_set_id(@user, '9A032D9C-3D9B-11E1-8634-00237D5BF174').count

    # Load the measure
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'episode'
    assert_response :redirect
    measure = Measure.where(cms_id: 'CMS68v4', user_id: @user.id).first
    assert_not_nil measure
    assert_equal true, measure.needs_finalize
    post :finalize, {"t551"=>{"hqmf_id"=>"40280381-4555-E1C1-0145-DC7DC26A44BF", "episode_ids"=>["OccurrenceAMedicationsEncounterCodeSet1"]}}
    assert_response :redirect
    assert_equal '40280381-4555-E1C1-0145-DC7DC26A44BF', measure[:hqmf_id]
    assert_equal '9A032D9C-3D9B-11E1-8634-00237D5BF174', measure[:hqmf_set_id]
    
    # Assert that there is still nothing in the archive for this measure
    assert_equal 0, ArchivedMeasure.by_user_and_hqmf_set_id(@user, '9A032D9C-3D9B-11E1-8634-00237D5BF174').count

    # Get the ObjectId of the current version of the measure
    measure_first_load_db_id = measure.id

    # Go the next version
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'base_example', 'CMS68v6.zip'), 'application/zip')
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'episode', hqmf_set_id: '9A032D9C-3D9B-11E1-8634-00237D5BF174'
    assert_response :redirect
    measure = Measure.where(hqmf_id: '40280381-51F0-825B-0152-227DFBAC15AA', user_id: @user.id).first
    assert_not_nil measure
    assert_equal true, measure.needs_finalize
    post :finalize, {"t551"=>{"hqmf_id"=>"40280381-51F0-825B-0152-227DFBAC15AA", "episode_ids"=>["OccurrenceA_MedicationsEncounterCodeSet_EncounterPerformed_40280381_3e93_d1af_013e_a36090dc2cf5_source"], "titles"=>{"0"=>"Population Criteria Section"}}}
    assert_response :redirect
    assert_equal '40280381-51F0-825B-0152-227DFBAC15AA', measure[:hqmf_id], "Loaded measure does not have the correct hqmf_id"
    assert_equal '9A032D9C-3D9B-11E1-8634-00237D5BF174', measure[:hqmf_set_id], "Loaded measure does not have the correct hqmf_set_id"

    # Assert that there is now an entry in the archive for this measure
    measure_from_archive = ArchivedMeasure.where(hqmf_set_id: '9A032D9C-3D9B-11E1-8634-00237D5BF174', user_id: @user.id)
    assert_equal 1, measure_from_archive.count
    assert_equal measure_first_load_db_id, measure_from_archive[0][:measure_db_id]
    assert_equal 'CMS68v4', measure_from_archive[0][:measure_content][:cms_id]

  end # measure archiving

  test 'measure upload summary' do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'base_example', 'CMS68v4.zip'), 'application/zip')

    # Assert measure is not yet loaded
    measure = Measure.where(hqmf_set_id: '9A032D9C-3D9B-11E1-8634-00237D5BF174', user_id: @user.id).first
    assert_nil measure
    
    # Assert that there is nothing in the upload summary for this measure
    assert_equal 0, UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(@user, '9A032D9C-3D9B-11E1-8634-00237D5BF174').count

    # Load the measure
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'episode'
    assert_response :redirect
    measure = Measure.where(cms_id: 'CMS68v4', user_id: @user.id).first
    assert_not_nil measure
    assert_equal true, measure.needs_finalize
    post :finalize, {"t551"=>{"hqmf_id"=>"40280381-4555-E1C1-0145-DC7DC26A44BF", "episode_ids"=>["OccurrenceAMedicationsEncounterCodeSet1"]}}
    assert_response :redirect
    assert_equal '40280381-4555-E1C1-0145-DC7DC26A44BF', measure[:hqmf_id], "Loaded measure does not have the correct hqmf_id"
    assert_equal '9A032D9C-3D9B-11E1-8634-00237D5BF174', measure[:hqmf_set_id], "Loaded measure does not have the correct hqmf_set_id"
    
    # Assert that there is information for the "post" upload portion
    # There is no "pre" upload section when the measure is loaded for the first time
    upload_summary = UploadSummary::MeasureSummary.where(hqmf_set_id: '9A032D9C-3D9B-11E1-8634-00237D5BF174', user_id: @user.id)
    assert_equal 1, upload_summary.count, "Failed upload_summary count"
    assert_nil upload_summary.first.measure_db_id_pre_upload
    assert_equal measure.id, upload_summary.first.measure_db_id_post_upload
    assert_nil upload_summary.first.cms_id_pre_upload
    assert_equal measure.cms_id, upload_summary.first.cms_id_post_upload
    assert_nil upload_summary.first.hqmf_version_number_pre_upload
    assert_equal measure.hqmf_version_number, upload_summary.first.hqmf_version_number_post_upload
    assert_equal 1, upload_summary.first.population_set_summaries.count 
    assert_equal 0, upload_summary.first.measure_population_set_count[:pre_upload]
    assert_equal 1, upload_summary.first.measure_population_set_count[:post_upload]
    assert_equal 0, upload_summary.first.population_set_summaries[0][:patients].count
    assert_equal 2, upload_summary.first.population_set_summaries[0][:summary].count
    assert_equal 0, upload_summary.first.population_set_summaries[0][:summary][:pass_after]
    assert_equal 0, upload_summary.first.population_set_summaries[0][:summary][:fail_after]
    
    # Load the patients for the measure
    records_set = File.join('records','measure_history_set', 'base_example')
    collection_fixtures(records_set)
    patients = Record.where(measure_ids: '9A032D9C-3D9B-11E1-8634-00237D5BF174')
    assert_not_empty patients, "No patients loaded for testing!!"
    associate_user_with_patients(@user, patients)
    
    patients.each do |patient|
      assert_equal measure[:hqmf_set_id], patient[:measure_ids][0]
      patient['user_id'] = BSON::ObjectId.from_string(patient['user_id']) if patient['user_id'].is_a?(String)
      # Unsetting the calc_results potentially loaded from the text fixtures so that test will use the latest results
      patient.unset(:calc_results)
      patient.save!
    end

    calculator = BonnieBackendCalculator.new
    
    measure.populations.each_with_index do |population_set, population_index|
      calculator.set_measure_and_population(measure, population_index, clear_db_cache: true, rationale: true)
      
      patients.each do |patient|
        patient.update_calc_results!(measure, population_index, calculator)
      end
    end

    # Test that there is still only one upload_summary
    upload_summary = UploadSummary::MeasureSummary.where(hqmf_set_id: '9A032D9C-3D9B-11E1-8634-00237D5BF174', user_id: @user.id)
    assert_equal 1, upload_summary.count, "Failed upload_summary count"

    # Get the ObjectId of the current version of the measure
    measure_first_load_db_id = measure.id
    measure_first_load_cms_id = measure.cms_id
    measure_first_load_hqmf_version_number_pre_upload = measure.hqmf_version_number

    # In order for the snapshot to persist it needs to be saved to an array
    measure_patients_pre_upload = Record.where(measure_ids: '9A032D9C-3D9B-11E1-8634-00237D5BF174', user_id: @user.id).to_a

    # Load the next version of the measure
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'measure_history_set', 'base_example', 'CMS68v6.zip'), 'application/zip')
    post :create, measure_file: measure_file, measure_type: 'ep', calculation_type: 'episode', hqmf_set_id: '9A032D9C-3D9B-11E1-8634-00237D5BF174'
    post :finalize, {"t551"=>{"hqmf_id"=>"40280381-51F0-825B-0152-227DFBAC15AA", "episode_ids"=>["OccurrenceA_MedicationsEncounterCodeSet_EncounterPerformed_40280381_3e93_d1af_013e_a36090dc2cf5_source"], "titles"=>{"0"=>"Population Criteria Section"}}}
    measure = Measure.where(cms_id: 'CMS68v6', user_id: @user.id).first
    assert_not_nil measure
    assert_equal '40280381-51F0-825B-0152-227DFBAC15AA', measure[:hqmf_id]
    assert_equal '9A032D9C-3D9B-11E1-8634-00237D5BF174', measure[:hqmf_set_id]

    upload_summary = UploadSummary::MeasureSummary.where(hqmf_set_id: '9A032D9C-3D9B-11E1-8634-00237D5BF174', hqmf_id: '40280381-51F0-825B-0152-227DFBAC15AA', user_id: @user.id).first
    
    # Test the primary fields
    assert_equal measure_first_load_db_id, upload_summary.measure_db_id_pre_upload
    assert_equal measure.id, upload_summary.measure_db_id_post_upload
    assert_equal measure_first_load_cms_id, upload_summary.cms_id_pre_upload
    assert_equal measure.cms_id, upload_summary.cms_id_post_upload
    assert_equal measure_first_load_hqmf_version_number_pre_upload, upload_summary.hqmf_version_number_pre_upload
    assert_equal measure.hqmf_version_number, upload_summary.hqmf_version_number_post_upload
    assert_equal 1, upload_summary.population_set_summaries.count
    assert_equal 1, upload_summary.measure_population_set_count[:pre_upload]
    assert_equal 1, upload_summary.measure_population_set_count[:post_upload]
    
    # Test the summary fields
    assert_not_nil upload_summary.population_set_summaries[0][:summary]
    assert_equal 2, upload_summary.population_set_summaries[0][:summary][:pass_before]
    assert_equal 2, upload_summary.population_set_summaries[0][:summary][:pass_after]
    assert_equal 0, upload_summary.population_set_summaries[0][:summary][:fail_before]
    assert_equal 0, upload_summary.population_set_summaries[0][:summary][:fail_after]
    
    # Test the patient fields
    measure_patients_post_upload = Record.where(measure_ids: '9A032D9C-3D9B-11E1-8634-00237D5BF174', user_id: @user.id)
    assert_equal 2, measure_patients_post_upload.count
    
    upload_summary.population_set_summaries[0][:patients].each do |patient_id, patient|
      
      # pre_load_patient is accessed as an array because of the way that the query data had to be persisted.
      # post_load_patient is accessed as a normal BSON document. 
      pre_load_patient = (measure_patients_pre_upload.select { |r| r.id.to_s == patient_id})[0]
      post_load_patient = measure_patients_post_upload.where(id: patient_id).first
      assert_not_nil pre_load_patient
      assert_not_nil post_load_patient

      assert_equal 0, (patient.keys - ["expected", "pre_upload_results", "pre_upload_status", "results_exceeds_storage_pre_upload", "post_upload_results", "post_upload_status", "results_exceeds_storage_post_upload", "patient_version_after_upload"]).length
      assert_not_nil patient[:expected]
      assert_equal 0, (patient[:expected].to_a - pre_load_patient[:expected_values][0].to_a).count

      assert_not_nil patient[:pre_upload_results]
      assert_equal 0, (patient[:pre_upload_results].to_a - pre_load_patient[:calc_results][0].to_a).count
      
      assert_not_nil patient[:pre_upload_status]
      assert_equal pre_load_patient[:calc_results][0][:status], patient[:pre_upload_status]

      assert_not_nil patient[:results_exceeds_storage_pre_upload]
      assert_equal pre_load_patient[:results_exceed_storage], patient[:results_exceeds_storage_pre_upload]

      assert_not_nil patient[:post_upload_results]
      assert_equal 0, (patient[:post_upload_results].to_a - post_load_patient[:calc_results][0].to_a).count

      assert_not_nil patient[:post_upload_status]
      assert_equal post_load_patient[:calc_results][0][:status], patient[:post_upload_status]

      assert_not_nil patient[:results_exceeds_storage_post_upload]
      assert_equal post_load_patient[:results_exceed_storage], patient[:results_exceeds_storage_post_upload]

      assert_not_nil patient[:patient_version_after_upload]
      assert_equal post_load_patient.version, patient[:patient_version_after_upload]
    end
    
  end # measure upload summary

end
