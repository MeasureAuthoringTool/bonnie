require 'test_helper'
require 'vcr_setup.rb'

class MeasuresControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @error_dir = File.join('log', 'load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    collection_fixtures('users')
    @user = User.by_email('bonnie@example.com').first
    sign_in @user
  end

  # This test is focusing on the actions around measure updates, particularly taking the snapshots of the patitents before and after
  test 'update measure version' do
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'CMS123v3.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    collection_fixtures('records')
    @patients = Record
    associate_user_with_patients(@user, @patients)

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

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'CMS123v5.zip'), 'application/zip')
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

  test 'walk through measure population_set change scenarios' do
    # Load version 1 of the measure. Starts with two population sets
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'CMS704_v1.1.zip'), 'application/zip')
    class << measure_file
      attr_reader :tempfile
    end

    collection_fixtures('records')
    @patients = Record
    associate_user_with_patients(@user, @patients)
    Record.each do |patient|
      if patient['user_id'].is_a?(String)
        patient['user_id'] = BSON::ObjectId.from_string(patient['user_id'])
        patient.save!
      end
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
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'CMS704_v2.2.zip'), 'application/zip')
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
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'CMS704_v3.1.zip'), 'application/zip')
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
    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'CMS704_v1.1.zip'), 'application/zip')
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

    measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measure_exports', 'CMS704_v2.3.zip'), 'application/zip')
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
end
