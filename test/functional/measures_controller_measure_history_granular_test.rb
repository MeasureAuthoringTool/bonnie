require 'test_helper'

class MeasuresControllerMeasureHistoryTest < ActionController::TestCase
include Devise::TestHelpers

  tests MeasuresController

  setup do
    dump_database
    users_set = File.join('users', 'base_set')
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    sign_in @user
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

      assert_equal 8, patient.keys.count
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

end # class