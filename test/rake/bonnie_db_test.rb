require 'test_helper'
require 'vcr_setup.rb'

class BonnieDbTest < ActiveSupport::TestCase
  setup do
    dump_database

    records_set = File.join("records", "CMS347v1")
    users_set = File.join("users", "base_set")
    cql_measures_set_1 = File.join("cql_measures", "CMS347v1")
    cql_measures_set_2 = File.join("cql_measures", "CMS160v6")
    cql_measures_set_3 = File.join("cql_measures", "CMS72v5")
    collection_fixtures(users_set, records_set)
    add_collection(cql_measures_set_1)
    add_collection(cql_measures_set_2)
    add_collection(cql_measures_set_3)

    @email = 'bonnie@example.com'
    @hqmf_set_id_1 = '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2'
    @hqmf_set_id_2 = '93F3479F-75D8-4731-9A3F-B7749D8BCD37'
    @hqmf_set_id_3 = 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'

    @user = User.by_email('bonnie@example.com').first

    associate_user_with_measures(@user, CqlMeasure.where(hqmf_set_id: @hqmf_set_id_1))
    associate_user_with_measures(@user, CqlMeasure.where(hqmf_set_id: @hqmf_set_id_2))
    associate_user_with_measures(@user, CqlMeasure.where(hqmf_set_id: @hqmf_set_id_3))
    # these patients are already associated with the source measure in the json file
    associate_user_with_patients(@source_user, Record.all)
  end

  test "resave measures" do
    measure_1 = CqlMeasure.where(hqmf_set_id: @hqmf_set_id_1).first
    measure_2 = CqlMeasure.where(hqmf_set_id: @hqmf_set_id_2).first
    measure_w_no_user = CqlMeasure.where(hqmf_set_id: @hqmf_set_id_3).first
    measure_w_no_user.user = nil
    measure_w_no_user.save!

    assert_output(
                  "Re-saving \"#{measure_1.title}\" [bonnie@example.com]\n" +
                  "Re-saving \"#{measure_w_no_user.title}\" [deleted user]\n" +
                  "Re-saving \"#{measure_2.title}\" [bonnie@example.com]\n"
                 ) { Rake::Task['bonnie:db:resave_measures'].execute }
  end

  test "successfully dump database" do
    path = Rails.root.join 'db', 'backups'
    original_number = Dir.entries(path).size
    Rake::Task['bonnie:db:dump'].execute
    assert_equal original_number + 1, Dir.entries(path).size
  end
end
