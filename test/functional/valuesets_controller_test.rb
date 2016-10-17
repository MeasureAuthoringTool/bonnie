require 'test_helper'

class ValuesetsControllerTest  < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    dump_database
    users_set = File.join("users","base_set")
    collection_fixtures(users_set, "draft_measures")
    @user = User.by_email('bonnie@example.com').first

    associate_user_with_measures(@user, Measure.all)

    @user.measures.first.value_set_oids.uniq.each_with_index do |oid|
      vs = HealthDataStandards::SVS::ValueSet.new(oid: oid)
      (0..10).each do |index|
        vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:"bar_#{index}")
      end
      vs.user = @user
      vs.save!
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

    vs_to_change = HealthDataStandards::SVS::ValueSet.where({oid: "2.16.840.1.114222.4.11.3591", user_id: @user.id}).first
    (vs_to_change.concepts.select {|c| c.code == 'bar_4'}).first.white_list = true
    (vs_to_change.concepts.select {|c| c.code == 'bar_8'}).first.black_list = true
    (vs_to_change.concepts.select {|c| c.code == 'bar_9'}).first.black_list = true

    post :update, {id: vs_to_change.id, concepts: vs_to_change.concepts.map {|c| c.attributes}}
    assert_response :success

    vs_to_change = HealthDataStandards::SVS::ValueSet.where({oid: "2.16.840.1.114222.4.11.3591", user_id: @user.id}).first
    # Verify if bar_4,bar_8 or bar_9 are not a valueset concept that they are neither white or black listed
    vs.concepts.each do |concept|
      unless ['bar_4', 'bar_8', 'bar_9'].include?(concept.code)
        assert !concept.white_list
        assert !concept.black_list
      end
    end
    # Verify that concepts are not sumultainiously black and white listed
    assert_equal true, (vs_to_change.concepts.select {|c| c.code == 'bar_4'}).first.white_list
    assert_equal false, (vs_to_change.concepts.select {|c| c.code == 'bar_4'}).first.black_list

    assert_equal false, (vs_to_change.concepts.select {|c| c.code == 'bar_8'}).first.white_list
    assert_equal true, (vs_to_change.concepts.select {|c| c.code == 'bar_8'}).first.black_list

    assert_equal false, (vs_to_change.concepts.select {|c| c.code == 'bar_9'}).first.white_list
    assert_equal true, (vs_to_change.concepts.select {|c| c.code == 'bar_9'}).first.black_list

  end

  end
