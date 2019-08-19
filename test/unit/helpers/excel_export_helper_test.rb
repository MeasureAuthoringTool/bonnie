require 'test_helper'
require './app/helpers/excel_export_helper'
require './lib/patient_export'

class ExcelExportHelperTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    @controller = PatientsController.new
    dump_database
    users_set = File.join('users', 'base_set')

    # CMS903 has stratifications and covers most of the edge cases
    # CMS134 is a simpler measure and also has a patient that fails due to invalid ucum units

    patients_set = File.join('cqm_patients', 'CMS903v0')
    simple_patients_set = File.join('cqm_patients', 'CMS134v6')

    collection_fixtures(users_set, patients_set, simple_patients_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_patients(@user, CQM::Patient.all)

    load_measure_fixtures_from_folder(File.join('measures', 'CMS903v0'), @user)
    load_measure_fixtures_from_folder(File.join('measures', 'CMS134v6'), @user)

    @measure = CQM::Measure.where({'cms_id' => 'CMS903v0'}).first
    @patients = CQM::Patient.by_user(@user).where({:measure_ids.in => [@measure.hqmf_set_id]})

    @simple_measure = CQM::Measure.where({'cms_id' => 'CMS134v6'}).first
    @simple_patients = CQM::Patient.by_user(@user).where({:measure_ids.in => [@simple_measure.hqmf_set_id]})

    backend_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS903', 'CMS903-results-stub.json')))
    unpretty_backend_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS903', 'CMS903-unpretty-results-stub.json')))
    simple_backend_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS134', 'CMS134-results-stub.json')))

    # modify the backend results keys to match the keys of our patients. The results stub's keys
    # are random since it was generated from a fixture
    @backend_results = {}
    @backend_results['5d56bb4b57a11ec4241eaf42'] = backend_results['5d56f42954eb3a09352b7b71'] # Visit_1ED
    @backend_results['5d51a41657a11e0c6d696a17'] = backend_results['5d56f42954eb3a09352b7b85'] # Visit_1Excl_2Ed
    @backend_results['5d56bd2d57a11ec4241eaf78'] = backend_results['5d56f42954eb3a09352b7b7a'] # Visits_2ED
    @backend_results['5d56bb2457a11ec4241eaf32'] = backend_results['5d56f42954eb3a09352b7b91'] # Visits_2Excl_2ED

    @unpretty_backend_results = {}
    @unpretty_backend_results['5d56bb4b57a11ec4241eaf42'] = unpretty_backend_results['5d56f52c88bb460fd4c08be3'] # Visit_1ED
    @unpretty_backend_results['5d51a41657a11e0c6d696a17'] = unpretty_backend_results['5d56f52c88bb460fd4c08bf7'] # Visit_1Excl_2Ed
    @unpretty_backend_results['5d56bd2d57a11ec4241eaf78'] = unpretty_backend_results['5d56f52c88bb460fd4c08bec'] # Visits_2ED
    @unpretty_backend_results['5d56bb2457a11ec4241eaf32'] = unpretty_backend_results['5d56f52c88bb460fd4c08c03'] # Visits_2Excl_2ED

    @simple_backend_results = {}

    @simple_backend_results['5a73955cb848465f695c4ecb'] = simple_backend_results['5b479b890a97b16d73ba4740']
    # Patient '5a58f001942c6d500fc8cb92' is not added because the fixture in cqm-execution was fixed so that it doesn't
    # have an invalid ucum unit. This simulates the failed_patient logic in bonnie.

    # These are the objects from the front end (measure-view.js.coffee) to compare with the ones we process
    # from the back end.  see test/fixtures/excel_export_helper/README.md for more details
    @calc_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS903', 'calc_results.json')))
    @calc_results_unpretty = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS903', 'calc_results_unpretty.json')))
    @patient_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS903', 'patient_details.json')))
    @population_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS903', 'population_details.json')))
    @statement_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS903', 'statement_details.json')))
    @simple_calc_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS134', 'calc_results.json')))
    @simple_patient_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS134', 'patient_details.json')))
    @simple_population_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS134', 'population_details.json')))
    @simple_statement_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'CMS134', 'statement_details.json')))

    # The front end results use cids as keys but the backend results use ids.
    @cid_to_measure_id_map = { 'c455': '5d56bb4b57a11ec4241eaf42',
                               'c464': '5d56bd2d57a11ec4241eaf78',
                               'c433': '5d51a41657a11e0c6d696a17',
                               'c444': '5d56bb2457a11ec4241eaf32' }.with_indifferent_access

    @simple_cid_to_measure_id_map = { 'c358': '5a58f001942c6d500fc8cb92',
                                      'c552': '5a73955cb848465f695c4ecb'}.with_indifferent_access

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
  end

  test 'population details are extracted' do
    population_details = ExcelExportHelper.get_population_details_from_measure(@measure, @backend_results)
    @population_details.keys.each do |key|
      @population_details[key]['criteria'] = (CQM::Measure::ALL_POPULATION_CODES & @population_details[key]['criteria']) + ['index']
    end
    assert_equal @population_details['c366'], population_details[0]
    assert_equal @population_details['c367'], population_details[1]
    assert_equal @population_details['c368'], population_details[2]
    assert_equal @population_details['c369'], population_details[3]
  end

  test 'statement details are extracted' do
    statement_details = ExcelExportHelper.get_statement_details_from_measure(@measure)
    assert_equal @statement_details, statement_details
  end

  test 'excel file is generated' do
    converted_results = ExcelExportHelper.convert_results_for_excel_export(@backend_results, @measure, @patients)
    statement_details = ExcelExportHelper.get_statement_details_from_measure(@measure)
    population_details = ExcelExportHelper.get_population_details_from_measure(@measure, @backend_results)
    patient_details = ExcelExportHelper.get_patient_details(@patients)
    backend_excel_package = PatientExport.export_excel_cql_file(converted_results, patient_details, population_details, statement_details, @measure.hqmf_set_id)
    backend_excel_file = Tempfile.new(['backend-excel-export-failed-patients', '.xlsx'])
    backend_excel_file.write backend_excel_package.to_stream.read
    backend_excel_file.rewind
    backend_excel_spreadsheet = Roo::Spreadsheet.open(backend_excel_file.path)

    get :excel_export, calc_results: @calc_results.to_json,
                       patient_details: @patient_details.to_json,
                       population_details: @population_details.to_json,
                       statement_details: @statement_details.to_json,
                       file_name: 'frontend-excel-export',
                       measure_hqmf_set_id: @measure.hqmf_set_id

    frontend_excel_file = Tempfile.new(['frontend-excel-export', '.xlsx'])
    frontend_excel_file.write(response.body)
    frontend_excel_file.rewind
    frontend_excel_spreadsheet = Roo::Spreadsheet.open(frontend_excel_file.path)
    compare_excel_spreadsheets(backend_excel_spreadsheet, frontend_excel_spreadsheet, patient_details.keys.length)
  end

  test 'result truncation truncates long strings' do
    long_string = 'a' * 400000
    truncated_string = PatientExport.truncate_result(long_string)
    # excel has a maximum character restriction on cells of 32,767 characters
    assert_equal true, truncated_string.length < 32767
    assert_equal true, (truncated_string.include? 'Entry Truncated To Fit Cell')
  end

  test 'result truncation doesnt truncate short strings' do
    short_string = 'short_string'
    truncated_string = PatientExport.truncate_result(short_string)
    assert_equal short_string, truncated_string
  end

  def compare_excel_spreadsheets(backend_excel_spreadsheet, frontend_excel_spreadsheet, number_of_patients)
    # Verify the sheet titles are the same
    assert_equal backend_excel_spreadsheet.sheets, frontend_excel_spreadsheet.sheets

    backend_excel_spreadsheet.sheets.each do |population_set|
      next if population_set == "KEY"
      backend_sheet = backend_excel_spreadsheet.sheet(population_set)
      frontend_sheet = frontend_excel_spreadsheet.sheet(population_set)

      # Column headers should be the same
      backend_patient_rows = []
      frontend_patient_rows = []

      # check header separately, always the 3rd row
      assert_equal backend_sheet.row(2), frontend_sheet.row(2)

      # sort patients because they are in different orders
      first_patient_row_index = 3

      # find which columns contain first and last names (this can change depending on the population)
      last_name_column_index = backend_sheet.row(2).find_index('last')
      first_name_column_index = backend_sheet.row(2).find_index('first')
      (first_patient_row_index..(number_of_patients + first_patient_row_index - 1)).each do |row_index|
        # add an extra 'column' which uses full name to make the sorting key more unique
        backend_row = backend_sheet.row(row_index)
        backend_row.push(backend_row[first_name_column_index] + backend_row[last_name_column_index])
        backend_patient_rows.push(backend_row)

        frontend_row = frontend_sheet.row(row_index)
        frontend_row.push(frontend_row[first_name_column_index] + frontend_row[last_name_column_index])
        frontend_patient_rows.push(frontend_row)
      end

      # sort the patients by our generated key, which is now the last element in the row
      sorted_backend_rows = backend_patient_rows.sort_by { |a| a[-1] }
      sorted_frontend_rows = frontend_patient_rows.sort_by { |a| a[-1] }
      assert_equal sorted_backend_rows, sorted_frontend_rows
    end
  end
end
