require 'test_helper'
require 'vcr_setup.rb'

class CqlToElmHelperTest < ActiveSupport::TestCase

  include WebMock::API

  setup do
    dump_database
    load_measure_fixtures_from_folder(File.join('measures', 'CMS160v6'))
    @measure = CQM::Measure.first
  end

  test 'translate_cql_to_elm produces json' do
    VCR.use_cassette('valid_translation_json_response') do
      elm_json, elm_xml = CqlToElmHelper.translate_cql_to_elm(@measure[:cql])
      assert_equal 1, elm_json.count
      assert_equal 1, elm_xml.count
    end
  end
end
