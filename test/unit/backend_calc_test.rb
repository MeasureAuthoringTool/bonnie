require 'test_helper'
require 'vcr_setup.rb'

class BonnieBackendCalculatorTest < ActiveSupport::TestCase

  include WebMock::API

  setup do
    dump_database
    patients_set = File.join('cqm_patients', 'CMS160v6')
    collection_fixtures(patients_set)
    load_measure_fixtures_from_folder(File.join('measures', 'CMS160v6'))
    @measure = CQM::Measure.order_by(:id => 'asc').first # we order_by to make sure we pull the same measure across runs
  end

  test "calculation completes test" do
    VCR.use_cassette('backend_calculator_test') do
      patients = CQM::Patient.where('measure_ids'=>{'$in'=>[@measure.hqmf_set_id]})
      options = {}

      r = BonnieBackendCalculator.calculate(@measure, patients, options)
      assert_equal "complete", r["5d278bbd31fe5f6f3e4b6d36"]["PopulationCriteria1"]["state"]
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
