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
      measure = CqlMeasure.first
      patients = Record.where('measure_ids'=>{'$in'=>[measure.hqmf_set_id]})
      value_sets = measure.value_sets
      options = {
        prettyPrint: true
      }
      r = BonnieBackendCalculator.calculate(measure, patients, value_sets, options)

      assert_equal measure.to_json, r['measure'].to_json
      assert_equal value_sets.to_json, r['valueSets'].to_json
      assert_equal options.to_json, r['options'].to_json

      # patients are converted so we dont expect them to be echoed identically, just check a few fields
      assert_equal patients.first['first'], r['patients'].first['givenNames'][0]
      assert_equal patients.first['last'], r['patients'].first['familyName']

    end
  end
end
