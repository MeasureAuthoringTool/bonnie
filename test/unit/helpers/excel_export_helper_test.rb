require 'test_helper'
require './app/helpers/excel_export_helper'

class ExcelExportHelperTest < ActionView::TestCase

  setup do
    dump_database
    users_set = File.join('users', 'base_set')
    measures_set = File.join('cql_measures', 'core_measures', 'CMS32v7')
    records_set = File.join('records','core_measures', 'CMS32v7')
    collection_fixtures(measures_set, users_set, records_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_patients(@user, Record.all)
    associate_user_with_measures(@user, Measure.all)
    @measure = CqlMeasure.where({'cms_id' => 'CMS32v7'}).first
    # TODO: Use CMS134v6 for more tests with a measure without multiple pops/strats
    # @simple_measure = CqlMeasure.where('cms_id' => 'CMS134v6').first
    @patients = Record.by_user(@user).where({:measure_ids.in => [@measure.hqmf_set_id]})
    backend_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS32-results-stub.json')))
    unpretty_backend_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS32-unpretty-results-stub.json')))
    # modify the backend results keys to match the keys of our patients. The results stub's keys
    # are random since it was generated from a fixture
    @backend_results = {}
    @backend_results['5a58e9b6942c6d4bb26bb2f6'] = backend_results['5b4675d11f994e831b2146b1'] # Visit_1ED
    @backend_results['5a593ff0942c6d0773593dff'] = backend_results['5b4675d11f994e831b2146b8'] # Visit_1Excl_2Ed
    @backend_results['5a593d66942c6d0773593d97'] = backend_results['5b4675d11f994e831b2146c0'] # Visits_2ED
    @backend_results['5a5940ba942c6d0c717eeece'] = backend_results['5b4675d11f994e831b2146c8'] # Visits_2Excl_2ED

    @unpretty_backend_results = {}
    @unpretty_backend_results['5a58e9b6942c6d4bb26bb2f6'] = unpretty_backend_results['5b474ad52f8e3a17057c855f'] # Visit_1ED
    @unpretty_backend_results['5a593ff0942c6d0773593dff'] = unpretty_backend_results['5b474ad52f8e3a17057c8566'] # Visit_1Excl_2Ed
    @unpretty_backend_results['5a593d66942c6d0773593d97'] = unpretty_backend_results['5b474ad52f8e3a17057c856e'] # Visits_2ED
    @unpretty_backend_results['5a5940ba942c6d0c717eeece'] = unpretty_backend_results['5b474ad52f8e3a17057c8576'] # Visits_2Excl_2ED

    # These are the objects from the front end (measure-view.js.coffee) to compare with the ones we process
    # from the back end.  see test/fixtures/excel_export_helper/README.md for more details
    @calc_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'calc_results.json')))
    @calc_results_unpretty = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'calc_results_unpretty.json')))
    @patient_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'patient_details.json')))
    @population_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'population_details.json')))
    @statement_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'statement_details.json')))
    # The front end results use cids as keys but the backend results use ids.
    @cid_to_measure_id_map = { 'c320': '5a58e9b6942c6d4bb26bb2f6',
                               'c468': '5a593d66942c6d0773593d97',
                               'c495': '5a593ff0942c6d0773593dff',
                               'c523': '5a5940ba942c6d0c717eeece' }.with_indifferent_access
  end

  test 'backend results are converted' do
    converted_results = ExcelExportHelper.convert_results_for_excel_export(@backend_results, @measure, @patients)
    @calc_results.zip(converted_results).each do |calc_result, converted_result|
      @cid_to_measure_id_map.each_pair do | cid, id |
        assert_equal calc_result[1][cid], converted_result[1][id]
      end
    end
  end

  test 'backend results are converted if pretty is not present' do
    converted_unpretty_results = ExcelExportHelper.convert_results_for_excel_export(@unpretty_backend_results, @measure, @patients)
    @calc_results_unpretty.zip(converted_unpretty_results).each do |calc_result, converted_result|
      @cid_to_measure_id_map.each_pair do | cid, id |
        assert_equal calc_result[1][cid], converted_result[1][id]
      end
    end
  end

  test 'patient details are extracted' do
    patient_details = ExcelExportHelper.get_patient_details(@patients)
    @cid_to_measure_id_map.with_indifferent_access.each_pair do |cid, measure_id|
      assert_equal @patient_details[cid].keys, patient_details[measure_id].keys
      @patient_details[cid].each_key do |key|
        if @patient_details[cid][key].nil?
          assert_nil patient_details[measure_id][key]
        else
          assert_equal @patient_details[cid][key], patient_details[measure_id][key]
        end
      end
    end
  end

  test 'population details are extracted' do
    population_details = ExcelExportHelper.get_population_details_from_measure(@measure, @backend_results)
    assert_equal @population_details['c89'], population_details[0]
    assert_equal @population_details['c90'], population_details[1]
    assert_equal @population_details['c91'], population_details[2]
    assert_equal @population_details['c92'], population_details[3]
  end

  test 'statement details are extracted' do
    statement_details = ExcelExportHelper.get_statement_details_from_measure(@measure)
    assert_equal @statement_details, statement_details
  end

  test 'excel file is generated with converted arguments' do
    converted_results = ExcelExportHelper.convert_results_for_excel_export(@backend_results, @measure, @patients)
    statement_details = ExcelExportHelper.get_statement_details_from_measure(@measure)
    population_details = ExcelExportHelper.get_population_details_from_measure(@measure, @backend_results)
    patient_details = ExcelExportHelper.get_patient_details(@patients)
    excel_package = PatientExport.export_excel_cql_file(converted_results, patient_details, population_details, statement_details)
    # TODO: how to test this--load excel fixture and look at rows? might be different order
    # File.open('excel_test.xlsx', 'w') {|file| file.write excel_package.to_stream.read}
  end
end
