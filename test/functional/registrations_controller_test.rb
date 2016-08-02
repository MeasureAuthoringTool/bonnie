require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]

    dump_database
    collection_fixtures("users", "records", "draft_measures")
    @user = User.by_email('bonnie@example.com').first
    @user.grant_portfolio
    
    associate_user_with_measures(@user,Measure.all)
    associate_user_with_patients(@user,Record.all)

    @user.measures.each do |measure|
      measure.value_set_oids.uniq.each do |oid|
        vs = HealthDataStandards::SVS::ValueSet.new(oid: oid)
        vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:'bar')
        vs.save!
        measure.bonnie_hashes.push(vs.bonnie_version_hash)
      end
    end
  end

  test "yield resource to block on update success" do
    sign_in @user
    assert_equal false, @user.crosswalk_enabled
    Measure.by_user(@user).each do |measure|
      assert !measure.map_fns.compact.empty?
    end
    put :update, { user: { current_password: 'Test1234!', crosswalk_enabled: true } }
    @user.reload
    assert_equal true, @user.crosswalk_enabled
    Measure.by_user(@user).each do |measure|
      assert measure.map_fns.compact.empty?
    end
  end

end
