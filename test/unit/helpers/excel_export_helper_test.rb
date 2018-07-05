require 'test_helper'
require './app/helpers/excel_export_helper'

class ExcelExportHelperTest < ActionView::TestCase

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    measures_set = File.join("cql_measures", "core_measures", "CMS160v6")
    records_set = File.join("records","core_measures", "CMS160v6")
    collection_fixtures(measures_set, users_set, records_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_patients(@user, Record.all)
    associate_user_with_measures(@user, Measure.all)
    @measure = CqlMeasure.where({"cms_id" => "CMS160v6"}).first
    @patients = Record.by_user(@user).where({:measure_ids.in => [@measure.hqmf_set_id]})
  end

  test 'patient details are extracted' do
    # TODO fill test out
    assert_equal 2, @patients.length
  end
end
