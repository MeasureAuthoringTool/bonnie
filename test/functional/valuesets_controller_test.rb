require 'test_helper'

class ValuesetsControllerTest  < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    dump_database
    collection_fixtures("users", "draft_measures")
    @user = User.by_email('bonnie@example.com').first

    associate_user_with_measures(@user,Measure.all)

    @user.measures.each do |measure|
      measure.value_set_oids.uniq.each_with_index do |oid|
        vs = HealthDataStandards::SVS::ValueSet.new(oid: oid)
        vs.version = "TEST"
        (0..10).each do |index|
          vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:"bar_#{index}")
        end
        vs.save!
        measure.bonnie_hashes.push(vs.bonnie_version_hash)
      end
    end
    sign_in @user
  end

  test "update value sets" do

    vs = HealthDataStandards::SVS::ValueSet.all.first
    post :update, {id: vs.id, concepts: vs.concepts.map {|c| c.attributes}}
    assert_response :success
    vs.reload
    vs.concepts.each do |concept|
      assert !concept.white_list
      assert !concept.black_list
    end

    vs_to_change = HealthDataStandards::SVS::ValueSet.where({bonnie_version_hash: "2f96447ca313cd6b9f3ceb15ac9ff14a"}).first

    (vs_to_change.concepts.select {|c| c.code == 'bar_4'}).first.white_list = true
    (vs_to_change.concepts.select {|c| c.code == 'bar_8'}).first.black_list = true
    (vs_to_change.concepts.select {|c| c.code == 'bar_9'}).first.black_list = true

    post :update, {id: vs_to_change.id, concepts: vs_to_change.concepts.map {|c| c.attributes}}
    assert_response :success

    vs_to_change = HealthDataStandards::SVS::ValueSet.where({bonnie_version_hash: "2f96447ca313cd6b9f3ceb15ac9ff14a"}).first
    vs.concepts.each do |concept|
      unless ['bar_4','bar_8','bar_9'].include?(concept.code)
        assert !concept.white_list
        assert !concept.black_list
      end
    end

    assert_equal true, (vs_to_change.concepts.select {|c| c.code == 'bar_4'}).first.white_list
    assert_equal false, (vs_to_change.concepts.select {|c| c.code == 'bar_4'}).first.black_list

    assert_equal false, (vs_to_change.concepts.select {|c| c.code == 'bar_8'}).first.white_list
    assert_equal true, (vs_to_change.concepts.select {|c| c.code == 'bar_8'}).first.black_list

    assert_equal false, (vs_to_change.concepts.select {|c| c.code == 'bar_9'}).first.white_list
    assert_equal true, (vs_to_change.concepts.select {|c| c.code == 'bar_9'}).first.black_list

  end

  end
