require 'test_helper'
require 'vcr_setup.rb'

class BonnieBackendCalculatorTest < ActiveSupport::TestCase

  setup do
    dump_database
    measures_set = File.join("cql_measures", "core_measures", "CMS160v6")
    records_set = File.join("records", "core_measures", "CMS160v6")
    value_sets = File.join("health_data_standards_svs_value_sets", "core_measures", "CMS160v6")
    collection_fixtures(measures_set, records_set, value_sets)
  end

  # This test will very likely need to be changed once the calculation service is working, 
  # right now the service just echoes, so this test makes sure the parsing is working etc
  test "echo test" do
    VCR.use_cassette('backend_calculator_echo_test') do
      measure = CqlMeasure.order_by(:id => 'asc').first # we order_by to make sure we pull the same measure across runs
      patients = Record.where('measure_ids'=>{'$in'=>[measure.hqmf_set_id]})
      value_sets = measure.value_sets
      options = {
        prettyPrint: true
      }
      r = BonnieBackendCalculator.calculate(measure, patients, value_sets, options)

      assert_equal measure.to_json, r['measure'].to_json
      assert_equal options.to_json, r['options'].to_json
      
      # since we might get value sets and patients in different order from mongo across runs, check that some sorted properties match
      assert_equal value_sets.collect(&:oid).sort, r['valueSets'].collect { |vs| vs['oid'] }.sort
      assert_equal value_sets.collect(&:display_name).sort, r['valueSets'].collect { |vs| vs['display_name'] }.sort

      # note patients are converted so field names change
      assert_equal patients.collect(&:first).sort, r['patients'].collect { |p| p['givenNames'][0] }.sort
      assert_equal patients.collect(&:last).sort, r['patients'].collect { |p| p['familyName'] }.sort

    end
  end
end
