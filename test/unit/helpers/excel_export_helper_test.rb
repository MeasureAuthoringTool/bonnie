require 'test_helper'
require './app/helpers/excel_export_helper'

class ExcelExportHelperTest < ActionView::TestCase

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    measures_set = File.join("cql_measures", "core_measures", "CMS32v7")
    records_set = File.join("records","core_measures", "CMS32v7")
    collection_fixtures(measures_set, users_set, records_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_patients(@user, Record.all)
    associate_user_with_measures(@user, Measure.all)
    @measure = CqlMeasure.where({"cms_id" => "CMS32v7"}).first
    @patients = Record.by_user(@user).where({:measure_ids.in => [@measure.hqmf_set_id]})

    @calc_results = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'calc_results.json')))
    @patient_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'patient_details.json')))
    @population_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'population_details.json')))
    @statement_details = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'excel_export_helper', 'statement_details.json')))
  end

  test 'patient details are extracted' do
    cid_to_measure_id_map = { 'c320': '5a58e9b6942c6d4bb26bb2f6', 'c468': '5a593d66942c6d0773593d97', 'c495': '5a593ff0942c6d0773593dff', 'c523': '5a5940ba942c6d0c717eeece'}
    patient_details = ExcelExportHelper.get_patient_details(@patients).with_indifferent_access
    cid_to_measure_id_map.with_indifferent_access.each_pair do | cid, measure_id |
      assert_equal @patient_details[cid].keys, patient_details[measure_id].keys
      @patient_details[cid].keys.each do |key|
        if @patient_details[cid][key].nil?
          assert_nil patient_details[measure_id][key]
        else
          assert_equal @patient_details[cid][key], patient_details[measure_id][key]
        end
      end
    end
  end

  test 'population details are extracted' do
    population_details = get_population_details_from_measure(@measure, @calc_results)
    assert_equal 4, population_details.length
  end

  test 'statement details are extracted' do
    statement_details = ExcelExportHelper.get_statement_details_from_measure(@measure).with_indifferent_access
    assert_equal @statement_details, statement_details
  end
end
