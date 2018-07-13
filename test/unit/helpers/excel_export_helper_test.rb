require 'test_helper'
require './app/helpers/excel_export_helper'
require './app/helpers/patient_helper'
class ExcelExportHelperTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @controller = PatientsController.new
    dump_database
    users_set = File.join('users', 'base_set')

    # CMS32 has stratifications and covers most of the edge cases
    measures_set = File.join('cql_measures', 'core_measures', 'CMS32v7')
    records_set = File.join('records','core_measures', 'CMS32v7')

    # CMS134 is a simpler measure and also has a patient that fails due to invalid ucum units
    simple_measures_set = File.join('cql_measures', 'core_measures', 'CMS134v6')
    simple_records_set = File.join('records','core_measures', 'CMS134v6')

    collection_fixtures(measures_set, users_set, records_set, simple_measures_set, simple_records_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_patients(@user, Record.all)
    associate_user_with_measures(@user, Measure.all)
    @measure = CqlMeasure.where({'cms_id' => 'CMS32v7'}).first
    @patients = Record.by_user(@user).where({:measure_ids.in => [@measure.hqmf_set_id]})

    @simple_measure = CqlMeasure.where({'cms_id' => 'CMS134v6'}).first
    @simple_patients = Record.by_user(@user).where({:measure_ids.in => [@simple_measure.hqmf_set_id]})

    backend_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS32', 'CMS32-results-stub.json')))
    unpretty_backend_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS32', 'CMS32-unpretty-results-stub.json')))
    simple_backend_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS134', 'CMS134-results-stub.json')))

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

    @simple_backend_results = {}
    @simple_backend_results['5a58f001942c6d500fc8cb92'] = simple_backend_results['5b479b890a97b16d73ba4748']
    @simple_backend_results['5a73955cb848465f695c4ecb'] = simple_backend_results['5b479b890a97b16d73ba4740']

    # These are the objects from the front end (measure-view.js.coffee) to compare with the ones we process
    # from the back end.  see test/fixtures/excel_export_helper/README.md for more details
    @calc_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS32', 'calc_results.json')))
    @calc_results_unpretty = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS32', 'calc_results_unpretty.json')))
    @patient_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS32', 'patient_details.json')))
    @population_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS32', 'population_details.json')))
    @statement_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS32', 'statement_details.json')))
    @simple_calc_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS134', 'calc_results.json')))
    @simple_patient_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS134', 'patient_details.json')))
    @simple_population_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS134', 'population_details.json')))
    @simple_statement_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS134', 'statement_details.json')))

    # The front end results use cids as keys but the backend results use ids.
    @cid_to_measure_id_map = { 'c320': '5a58e9b6942c6d4bb26bb2f6',
                               'c468': '5a593d66942c6d0773593d97',
                               'c495': '5a593ff0942c6d0773593dff',
                               'c523': '5a5940ba942c6d0c717eeece' }.with_indifferent_access

    @simple_cid_to_measure_id_map = { 'c358': '5a58f001942c6d500fc8cb92',
                                      'c552': '5a73955cb848465f695c4ecb'}

    sign_in @user
  end

  test 'backend results are converted' do
    converted_results = ExcelExportHelper.convert_results_for_excel_export(@backend_results, @measure, @patients)
    @calc_results.values.zip(converted_results.values).each do |calc_result, converted_result|
      @cid_to_measure_id_map.each_pair do |cid, id|
        assert_equal calc_result[cid], converted_result[id]
      end
    end
  end

  test 'backend results are converted with failed patients' do
    converted_results = ExcelExportHelper.convert_results_for_excel_export(@simple_backend_results, @measure, @patients)
    @simple_calc_results.values.zip(converted_results.values).each do |calc_result, converted_result|
      @simple_cid_to_measure_id_map.each_pair do |cid, id|
        assert_equal calc_result[cid], converted_result[id]
      end
    end
  end

  test 'backend results are converted if pretty is not present' do
    converted_unpretty_results = ExcelExportHelper.convert_results_for_excel_export(@unpretty_backend_results, @measure, @patients)
    @calc_results_unpretty.values.zip(converted_unpretty_results.values).each do |calc_result, converted_result|
      @cid_to_measure_id_map.each_pair do |cid, id|
        assert_equal calc_result[cid], converted_result[id]
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
    # TODO(Luke): test failed patients separately or add to cid_map and skip for other assert loops
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
    backend_results_with_failed_patients = add_failed_patients_to_results(@patients, @backend_results)

    converted_results = ExcelExportHelper.convert_results_for_excel_export(backend_results_with_failed_patients, @measure, @patients)
    statement_details = ExcelExportHelper.get_statement_details_from_measure(@measure)
    population_details = ExcelExportHelper.get_population_details_from_measure(@measure, backend_results_with_failed_patients)
    patient_details = ExcelExportHelper.get_patient_details(@patients)
    backend_excel_package = PatientExport.export_excel_cql_file(converted_results, patient_details, population_details, statement_details)
    backend_excel_file = Tempfile.new(['backend-excel-export-failed-patients', '.xlsx'])
    backend_excel_file.write backend_excel_package.to_stream.read
    backend_excel_file.rewind
    backend_excel_spreadsheet = Roo::Spreadsheet.open(backend_excel_file.path)

    get :excel_export, calc_results: @calc_results.to_json,
                       patient_details: @patient_details.to_json,
                       population_details: @population_details.to_json,
                       statement_details: @statement_details.to_json,
                       file_name: 'frontend-excel-export'

    frontend_excel_file = Tempfile.new(['frontend-excel-export', '.xlsx'])
    frontend_excel_file.write(response.body)
    frontend_excel_file.rewind
    frontend_excel_spreadsheet = Roo::Spreadsheet.open(frontend_excel_file.path)

    assert_equal backend_excel_spreadsheet.sheets, frontend_excel_spreadsheet.sheets
    backend_excel_spreadsheet.sheets.each do |population_set|
      next if population_set == "KEY"
      backend_sheet = backend_excel_spreadsheet.sheet(population_set)
      frontend_sheet = frontend_excel_spreadsheet.sheet(population_set)

      # Column headers should be the same
      assert_equal backend_sheet.row(2), frontend_sheet.row(2)

      # Compare patients(rows), which are in different order but should be equal.
      # Patient 2 ED Visits
      assert_equal backend_sheet.row(3), frontend_sheet.row(4)

      # Patient 2 ED Visits 2 Excl
      assert_equal backend_sheet.row(4), frontend_sheet.row(6)

      # Patient 2 ED Visits 1 Excl
      assert_equal backend_sheet.row(5), frontend_sheet.row(5)

      # Patient 1 ED Visit
      assert_equal backend_sheet.row(6), frontend_sheet.row(3)
    end
  end

  test 'excel file is generated if there is a failed patient' do
    backend_results_with_failed_patients = add_failed_patients_to_results(@simple_patients, @simple_backend_results)

    converted_results = ExcelExportHelper.convert_results_for_excel_export(backend_results_with_failed_patients, @simple_measure, @simple_patients)
    statement_details = ExcelExportHelper.get_statement_details_from_measure(@simple_measure)
    population_details = ExcelExportHelper.get_population_details_from_measure(@simple_measure, backend_results_with_failed_patients)
    patient_details = ExcelExportHelper.get_patient_details(@simple_patients)
    backend_excel_package = PatientExport.export_excel_cql_file(converted_results, patient_details, population_details, statement_details)
    backend_excel_file = Tempfile.new(['backend-excel-export-failed-patients', '.xlsx'])
    backend_excel_file.write backend_excel_package.to_stream.read
    backend_excel_file.rewind
    backend_excel_spreadsheet = Roo::Spreadsheet.open(backend_excel_file.path)

    get :excel_export, calc_results: @simple_calc_results.to_json,
                       patient_details: @simple_patient_details.to_json,
                       population_details: @simple_population_details.to_json,
                       statement_details: @simple_statement_details.to_json,
                       file_name: 'frontend-excel-export-failed-patients'

    frontend_excel_file = Tempfile.new(['frontend-excel-export-failed-patients', '.xlsx'])
    frontend_excel_file.write(response.body)
    frontend_excel_file.rewind
    frontend_excel_spreadsheet = Roo::Spreadsheet.open(frontend_excel_file.path)

    backend_sheet = backend_excel_spreadsheet.sheet('1 - Population Criteria Section')
    frontend_sheet = frontend_excel_spreadsheet.sheet('1 - Population Criteria Section')

    # Column headers should be the same
    assert_equal backend_sheet.row(2), frontend_sheet.row(2)

    # Patient Numer Pass
    assert_equal backend_sheet.row(3), frontend_sheet.row(3)

    # Patient Denex Fail_Hospice_Not_Performed
    assert_equal backend_sheet.row(4), frontend_sheet.row(4)
  end

  def add_failed_patients_to_results(patients, results)
    # If patients can't be converted, the results object will have an extra field: 'failed_patients'
    # mimic the adding of 'failed_patients' by api_v1/measures_controller.rb
    qdm_patients, failed_patients = PatientHelper.convert_patient_models(patients)
    results_with_failed_patients = results
    results_with_failed_patients['failed_patients'] = failed_patients
    results_with_failed_patients
  end
end
