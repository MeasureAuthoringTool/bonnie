require 'test_helper'
require 'vcr_setup.rb'

class BonnieBackendCalculatorTest < ActiveSupport::TestCase

  include WebMock::API

  setup do
    dump_database
    measures_set = File.join("cql_measures", "core_measures", "CMS160v6")
    records_set = File.join("records", "core_measures", "CMS160v6")
    value_sets = File.join("health_data_standards_svs_value_sets", "core_measures", "CMS160v6")
    collection_fixtures(measures_set, records_set, value_sets)
    @measure = CQM::Measure.order_by(:id => 'asc').first # we order_by to make sure we pull the same measure across runs
  end

  test "calculation completes test" do
    VCR.use_cassette('backend_calculator_test') do
      patients = Record.where('measure_ids'=>{'$in'=>[@measure.hqmf_set_id]})
      options = {}

      r = BonnieBackendCalculator.calculate(@measure, patients, options)

      assert_equal "complete", r["5a9ee716b848465b0064f52c"]["PopulationCriteria1"]["state"]
    end
  end

  test "timeout test" do
    assert_raise BonnieBackendCalculator::RestException do
      stub_request(:post, BonnieBackendCalculator::CALCULATION_SERVICE_URL).to_timeout
      BonnieBackendCalculator.calculate(@measure, [], nil)
    end
    WebMock.reset! # stubs can interfere with other tests that are not expecting them, so you can reset
  end

  # if the server is running but the service is not, then the server will refuse the connection on that port and you will get an error as follows
  test "service down test" do
    assert_raise BonnieBackendCalculator::RestException do
      stub_request(:post, BonnieBackendCalculator::CALCULATION_SERVICE_URL).to_raise(Errno::ECONNREFUSED)
      BonnieBackendCalculator.calculate(@measure, [], nil)
    end
    WebMock.reset!
  end
end
