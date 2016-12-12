require 'test_helper'

class ArchivedMeasureTest < ActiveSupport::TestCase
  
  setup do
    dump_database
    measures_set = File.join("draft_measures", "base_set")
    collection_fixtures(measures_set)
    @measure = Measure.where({"cms_id" => "CMS138v2"}).first
  end
  
  test "Create ArchivedMeasure from Measure" do
    archived_measure = ArchivedMeasure.from_measure(@measure)
    assert_equal archived_measure.measure_db_id, @measure.id
    assert_equal archived_measure.hqmf_id, @measure.hqmf_id
    assert_equal archived_measure.hqmf_set_id, @measure.hqmf_set_id
    assert_equal archived_measure.measure_content, JSON.parse(@measure.to_json)
    assert_equal archived_measure.user, @measure.user
    assert_equal archived_measure.uploaded_at, @measure.created_at
  end
  
  test "Create Measure from Archived Measure" do
    archived_measure = ArchivedMeasure.from_measure(@measure)
    measure_from_archived = archived_measure.to_measure
    assert_equal @measure.to_json, measure_from_archived.to_json
  end

end
