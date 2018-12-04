require 'test_helper'
require 'vcr_setup.rb'

class BonniePatientsTest < ActiveSupport::TestCase
  setup do
    dump_database

    records_set = File.join("records", "core_measures", "CMS32v7")
    users_set = File.join("users", "base_set")
    cql_measures_set_1 = File.join("cql_measures", "core_measures", "CMS32v7")
    cql_measures_set_2 = File.join("cql_measures", "core_measures", "CMS160v6")
    cql_measures_set_3 = File.join("cql_measures", "core_measures", "CMS177v6")
    collection_fixtures(users_set, records_set)
    add_collection(cql_measures_set_1)
    add_collection(cql_measures_set_2)
    add_collection(cql_measures_set_3)

    @source_email = 'bonnie@example.com'
    @dest_email = 'user_admin@example.com'
    @source_hqmf_set_id = '3FD13096-2C8F-40B5-9297-B714E8DE9133'
    @dest2_hqmf_set_id = 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'
    @dest_hqmf_set_id = '848D09DE-7E6B-43C4-BEDD-5A2957CCFFE3'

    @source_user = User.by_email('bonnie@example.com').first
    @dest_user = User.by_email('user_admin@example.com').first

    associate_user_with_measures(@source_user, CqlMeasure.where(hqmf_set_id: @source_hqmf_set_id))
    associate_user_with_measures(@source_user, CqlMeasure.where(hqmf_set_id: @dest2_hqmf_set_id))
    associate_user_with_measures(@dest_user, CqlMeasure.where(hqmf_set_id: @dest_hqmf_set_id))
    # these patients are already associated with the source measure in the json file
    associate_user_with_patients(@source_user, Record.all)

  end

  test "copy_value_sets" do

    # setup for value sets

    # need to ensure users have bundles
    @source_user.send('ensure_bundle')
    @source_user.save!
    @dest_user.send('ensure_bundle')
    @dest_user.save!

    value_sets_hash_src = [
      {oid:"A", version:"1"},
      {oid:"A", version:"2"},
      {oid:"A", version:"3"},
      {oid:"B", version:"1"},
      {oid:"B", version:"2"},
      {oid:"C", version:"1"},
      {oid:"C", version:""},
      {oid:"D", version:""},
      {oid:"E", version:"1"},
      {oid:"F", version:""},
      {oid:"G", version:"1"}]

    value_sets_hash_src.each do |vs_obj|
      vs = HealthDataStandards::SVS::ValueSet.new(oid: vs_obj[:oid], version: vs_obj[:version])
      (0..10).each do |index|
        vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:"bar_#{index}")
      end
      vs.user = @source_user
      vs.bundle = @source_user.bundle
      vs.save!
    end

    value_sets_hash_dest = [
      {oid:"A", version:"1"}, # confirm this isn't replicated
      # confirm {oid:"A", version:"2"} is added
      {oid:"A", version:"3"}, # confirm this isn't replicated
      # confirm {oid:"B", version"1"} is added
      {oid:"B", version:"2"}, # confirm this isn't replicated
      # confirm {oid:"C", version:"1"} is added
      {oid:"C", version:""}, # confirm this isn't replicated
      {oid:"D", version:""}, # confirm this isn't replicated
      {oid:"E", version:"1"}, # confirm this isn't replicated
      # confirm {oid:"F", version:""} is added
      # confirm {oid:"G", version:"1"} is added
      {oid:"H", version:""} # confirm pre-existing, non-overlapping values don't disappear
    ]

    value_sets_hash_dest.each do |vs_obj|
      vs = HealthDataStandards::SVS::ValueSet.new(oid: vs_obj[:oid], version: vs_obj[:version])
      (0..10).each do |index|
        vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:"bar_#{index}")
      end
      vs.user = @dest_user
      vs.bundle = @dest_user.bundle
      vs.save!
    end

    # test the base case - no changes
    value_sets_src = HealthDataStandards::SVS::ValueSet.where(user_id: @source_user)
    value_sets_dest = HealthDataStandards::SVS::ValueSet.where(user_id: @dest_user)

    assert_equal(18, HealthDataStandards::SVS::ValueSet.count)

    assert_equal(11, value_sets_src.count)
    value_sets_src.each do |vs|
      assert_equal(@source_user, vs.user)
      assert_equal(@source_user.bundle, vs.bundle)
    end

    assert_equal(7, value_sets_dest.count)
    value_sets_dest.each do |vs|
      assert_equal(@dest_user, vs.user)
      assert_equal(@dest_user.bundle, vs.bundle)
    end

    # test transfer of value sets

    copy_value_sets(@dest_user, value_sets_src)

    value_sets_src = HealthDataStandards::SVS::ValueSet.where(user_id: @source_user)
    value_sets_dest = HealthDataStandards::SVS::ValueSet.where(user_id: @dest_user)

    # confirm nothing inadvertently changed
    assert_equal(11, value_sets_src.count)
    value_sets_src.each do |vs|
      assert_equal(@source_user, vs.user)
      assert_equal(@source_user.bundle, vs.bundle)
    end

    # confirm nothing unchanged
    assert_equal(12, value_sets_dest.count)
    value_sets_dest.each do |vs|
      assert_equal(@dest_user, vs.user)
      assert_equal(@dest_user.bundle, vs.bundle)
    end

    # confirmed everything in the source vs list is now in the dest vs list exactly once
    value_sets_hash_src.each do |vs_obj|
      set = HealthDataStandards::SVS::ValueSet.where(user_id: @dest_user, oid: vs_obj[:oid], version: vs_obj[:version])
      assert_equal(1, set.count)
    end
  end

end
